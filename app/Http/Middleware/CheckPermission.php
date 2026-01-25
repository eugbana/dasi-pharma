<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;
use Symfony\Component\HttpFoundation\Response;

/**
 * CheckPermission Middleware
 * 
 * Validates user permissions before allowing access to routes.
 * Supports checking multiple permissions with AND/OR logic.
 * Super Admin users bypass all permission checks.
 * 
 * Usage:
 * - Single permission: ->middleware('permission:sales.create')
 * - Multiple permissions (AND): ->middleware('permission:sales.create,inventory.view')
 * - Multiple permissions (OR): ->middleware('permission:sales.create|inventory.view')
 * - Mixed: ->middleware('permission:sales.create,inventory.view|reports.view')
 */
class CheckPermission
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     * @param  string  ...$permissions  Permission names to check
     */
    public function handle(Request $request, Closure $next, string ...$permissions): Response
    {
        $user = $request->user();

        // Check if user is authenticated
        if (!$user) {
            return $this->handleUnauthorized($request, 'Authentication required');
        }

        // Super Admin bypasses all permission checks
        if ($user->isSuperAdmin()) {
            return $next($request);
        }

        // If no permissions specified, just check authentication
        if (empty($permissions)) {
            return $next($request);
        }

        // Parse and check permissions
        $hasAccess = $this->checkPermissions($user, $permissions);

        if (!$hasAccess) {
            $this->logPermissionViolation($user, $permissions, $request);
            return $this->handleUnauthorized($request, 'Insufficient permissions');
        }

        return $next($request);
    }

    /**
     * Check if user has the required permissions.
     * 
     * Supports:
     * - AND logic: permissions separated by commas (user must have ALL)
     * - OR logic: permissions separated by pipes (user must have ANY)
     * 
     * @param  \App\Models\User  $user
     * @param  array  $permissions
     * @return bool
     */
    protected function checkPermissions($user, array $permissions): bool
    {
        // Join all permission strings
        $permissionString = implode(',', $permissions);

        // Check for OR logic (pipe separator)
        if (str_contains($permissionString, '|')) {
            return $this->checkOrPermissions($user, $permissionString);
        }

        // Default: AND logic (comma separator)
        return $this->checkAndPermissions($user, $permissionString);
    }

    /**
     * Check if user has ANY of the specified permissions (OR logic).
     * 
     * @param  \App\Models\User  $user
     * @param  string  $permissionString
     * @return bool
     */
    protected function checkOrPermissions($user, string $permissionString): bool
    {
        $permissionGroups = explode('|', $permissionString);

        foreach ($permissionGroups as $group) {
            $groupPermissions = array_map('trim', explode(',', $group));
            
            // Check if user has all permissions in this group
            if ($this->hasAllPermissions($user, $groupPermissions)) {
                return true;
            }
        }

        return false;
    }

    /**
     * Check if user has ALL of the specified permissions (AND logic).
     * 
     * @param  \App\Models\User  $user
     * @param  string  $permissionString
     * @return bool
     */
    protected function checkAndPermissions($user, string $permissionString): bool
    {
        $requiredPermissions = array_map('trim', explode(',', $permissionString));
        return $this->hasAllPermissions($user, $requiredPermissions);
    }

    /**
     * Check if user has all specified permissions.
     * 
     * @param  \App\Models\User  $user
     * @param  array  $permissions
     * @return bool
     */
    protected function hasAllPermissions($user, array $permissions): bool
    {
        foreach ($permissions as $permission) {
            if (!$user->hasPermission($permission)) {
                return false;
            }
        }

        return true;
    }

    /**
     * Log permission violation for security auditing.
     * 
     * @param  \App\Models\User  $user
     * @param  array  $permissions
     * @param  \Illuminate\Http\Request  $request
     * @return void
     */
    protected function logPermissionViolation($user, array $permissions, Request $request): void
    {
        Log::warning('Permission violation detected', [
            'user_id' => $user->id,
            'user_email' => $user->email,
            'user_role' => $user->role->name ?? 'Unknown',
            'required_permissions' => $permissions,
            'user_permissions' => $user->role?->permissions->pluck('name')->toArray() ?? [],
            'route' => $request->route()?->getName(),
            'url' => $request->fullUrl(),
            'method' => $request->method(),
            'ip' => $request->ip(),
            'user_agent' => $request->userAgent(),
            'timestamp' => now()->toDateTimeString(),
        ]);
    }

    /**
     * Handle unauthorized access.
     * 
     * @param  \Illuminate\Http\Request  $request
     * @param  string  $message
     * @return \Symfony\Component\HttpFoundation\Response
     */
    protected function handleUnauthorized(Request $request, string $message): Response
    {
        // For API requests, return JSON response
        if ($request->expectsJson() || $request->is('api/*')) {
            return response()->json([
                'success' => false,
                'message' => $message,
                'code' => 'PERMISSION_DENIED',
            ], 403);
        }

        // For web requests, abort with 403
        abort(403, $message);
    }
}

