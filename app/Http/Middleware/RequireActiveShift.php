<?php

namespace App\Http\Middleware;

use App\Services\POSSessionService;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * Middleware that requires an active shift for POS operations.
 */
class RequireActiveShift
{
    public function __construct(
        protected POSSessionService $sessionService
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

        // Check if shift is required
        if (!config('pos-desktop.session.require_shift', true)) {
            return $next($request);
        }

        // Check for active shift
        if (!$this->sessionService->hasActiveShift($user)) {
            return response()->json([
                'success' => false,
                'message' => 'An active shift is required to perform this operation',
                'code' => 'SHIFT_REQUIRED',
                'action' => 'start_shift',
            ], 403);
        }

        return $next($request);
    }
}

