<?php

namespace App\Http\Middleware;

use App\Services\POSAuditService;
use App\Services\POSSessionService;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * Middleware for POS desktop-specific security and session management.
 */
class POSDesktopMiddleware
{
    public function __construct(
        protected POSSessionService $sessionService,
        protected POSAuditService $auditService
    ) {}

    /**
     * Handle an incoming request.
     */
    public function handle(Request $request, Closure $next): Response
    {
        $user = $request->user();

        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'Authentication required',
                'code' => 'AUTH_REQUIRED',
            ], 401);
        }

        // Set user context for audit logging
        $this->auditService->setUser($user);

        // Check for session timeout
        if ($this->sessionService->isSessionTimedOut($user)) {
            return response()->json([
                'success' => false,
                'message' => 'Session timed out due to inactivity',
                'code' => 'SESSION_TIMEOUT',
            ], 401);
        }

        // Verify hardware ID matches (prevent session hijacking)
        if (!$this->verifyHardwareId($request)) {
            $this->auditService->logSecurity('Hardware ID mismatch detected', [
                'expected' => config('pos.hardware_id'),
                'received' => $request->header('X-Hardware-ID'),
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Invalid hardware identifier',
                'code' => 'HARDWARE_MISMATCH',
            ], 403);
        }

        // Check offline transaction limits
        if ($this->isOfflineMode($request) && !$this->checkOfflineLimits($user)) {
            return response()->json([
                'success' => false,
                'message' => 'Offline transaction limit reached. Please sync with server.',
                'code' => 'OFFLINE_LIMIT_REACHED',
            ], 403);
        }

        // Update activity timestamp
        $this->sessionService->updateActivity($user);

        // Add POS context to request
        $request->merge([
            'pos_context' => [
                'hardware_id' => config('pos.hardware_id'),
                'is_offline' => $this->isOfflineMode($request),
                'shift_id' => $this->sessionService->getCurrentShift($user)['id'] ?? null,
            ],
        ]);

        return $next($request);
    }

    /**
     * Verify the hardware ID header matches the configured ID.
     */
    protected function verifyHardwareId(Request $request): bool
    {
        // Skip verification in development
        if (app()->environment('local', 'testing')) {
            return true;
        }

        $expectedId = config('pos.hardware_id');
        $receivedId = $request->header('X-Hardware-ID');

        // Allow if no hardware ID is configured yet
        if (!$expectedId) {
            return true;
        }

        return $expectedId === $receivedId;
    }

    /**
     * Check if the request is in offline mode.
     */
    protected function isOfflineMode(Request $request): bool
    {
        return $request->header('X-Offline-Mode') === 'true' ||
               $request->boolean('offline_mode');
    }

    /**
     * Check if offline transaction limits are exceeded.
     */
    protected function checkOfflineLimits($user): bool
    {
        $maxTransactions = config('pos-desktop.security.max_offline_transactions', 100);
        $shift = $this->sessionService->getCurrentShift($user);

        if (!$shift) {
            return true;
        }

        $offlineTransactions = collect($shift['transactions'] ?? [])
            ->filter(fn($t) => ($t['offline'] ?? false) === true)
            ->count();

        return $offlineTransactions < $maxTransactions;
    }
}

