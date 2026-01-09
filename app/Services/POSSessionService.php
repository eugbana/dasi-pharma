<?php

namespace App\Services;

use App\Models\User;
use Carbon\Carbon;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Log;

/**
 * Manages POS session lifecycle including shifts, timeouts, and security.
 */
class POSSessionService
{
    protected int $sessionTimeout;
    protected bool $requireShift;

    public function __construct(int $sessionTimeout = 900, bool $requireShift = true)
    {
        $this->sessionTimeout = $sessionTimeout;
        $this->requireShift = $requireShift;
    }

    /**
     * Start a new shift for the user.
     */
    public function startShift(User $user, float $openingCash = 0.0): array
    {
        $shiftId = 'SHIFT-' . $user->id . '-' . now()->format('YmdHis');
        
        $shiftData = [
            'id' => $shiftId,
            'user_id' => $user->id,
            'user_name' => $user->name,
            'branch_id' => $user->branch_id,
            'started_at' => now()->toIso8601String(),
            'opening_cash' => $openingCash,
            'status' => 'active',
            'transactions' => [],
            'hardware_id' => config('pos.hardware_id'),
        ];

        // Store shift in cache (persisted to file for desktop)
        Cache::put("pos_shift_{$user->id}", $shiftData, now()->addHours(24));
        
        Log::channel('pos_audit')->info('Shift started', [
            'shift_id' => $shiftId,
            'user_id' => $user->id,
            'opening_cash' => $openingCash,
        ]);

        return $shiftData;
    }

    /**
     * End the current shift for the user.
     */
    public function endShift(User $user, float $closingCash = 0.0): array
    {
        $shiftData = $this->getCurrentShift($user);
        
        if (!$shiftData) {
            throw new \RuntimeException('No active shift found for user');
        }

        $shiftData['ended_at'] = now()->toIso8601String();
        $shiftData['closing_cash'] = $closingCash;
        $shiftData['status'] = 'closed';
        $shiftData['duration_minutes'] = Carbon::parse($shiftData['started_at'])->diffInMinutes(now());

        // Calculate shift summary
        $shiftData['summary'] = $this->calculateShiftSummary($shiftData);

        // Archive shift data
        $this->archiveShift($shiftData);
        
        // Clear active shift
        Cache::forget("pos_shift_{$user->id}");

        Log::channel('pos_audit')->info('Shift ended', [
            'shift_id' => $shiftData['id'],
            'user_id' => $user->id,
            'closing_cash' => $closingCash,
            'duration_minutes' => $shiftData['duration_minutes'],
        ]);

        return $shiftData;
    }

    /**
     * Get the current active shift for a user.
     */
    public function getCurrentShift(User $user): ?array
    {
        return Cache::get("pos_shift_{$user->id}");
    }

    /**
     * Check if user has an active shift.
     */
    public function hasActiveShift(User $user): bool
    {
        $shift = $this->getCurrentShift($user);
        return $shift && $shift['status'] === 'active';
    }

    /**
     * Record a transaction in the current shift.
     */
    public function recordTransaction(User $user, string $type, float $amount, array $details = []): void
    {
        $shiftData = $this->getCurrentShift($user);
        
        if (!$shiftData) {
            return;
        }

        $shiftData['transactions'][] = [
            'type' => $type,
            'amount' => $amount,
            'timestamp' => now()->toIso8601String(),
            'details' => $details,
        ];

        Cache::put("pos_shift_{$user->id}", $shiftData, now()->addHours(24));
    }

    /**
     * Check if session has timed out.
     */
    public function isSessionTimedOut(User $user): bool
    {
        $lastActivity = Cache::get("pos_last_activity_{$user->id}");
        
        if (!$lastActivity) {
            return false;
        }

        return Carbon::parse($lastActivity)->addSeconds($this->sessionTimeout)->isPast();
    }

    /**
     * Update last activity timestamp.
     */
    public function updateActivity(User $user): void
    {
        Cache::put("pos_last_activity_{$user->id}", now()->toIso8601String(), now()->addHours(24));
    }

    /**
     * Calculate shift summary statistics.
     */
    protected function calculateShiftSummary(array $shiftData): array
    {
        $transactions = collect($shiftData['transactions']);

        return [
            'total_sales' => $transactions->where('type', 'sale')->sum('amount'),
            'total_returns' => $transactions->where('type', 'return')->sum('amount'),
            'total_voids' => $transactions->where('type', 'void')->sum('amount'),
            'transaction_count' => $transactions->count(),
            'cash_difference' => $shiftData['closing_cash'] - $shiftData['opening_cash'] - 
                $transactions->where('type', 'sale')->sum('amount') +
                $transactions->where('type', 'return')->sum('amount'),
        ];
    }

    /**
     * Archive completed shift data.
     */
    protected function archiveShift(array $shiftData): void
    {
        $archivePath = storage_path('pos/shifts/' . date('Y/m'));
        
        if (!is_dir($archivePath)) {
            mkdir($archivePath, 0755, true);
        }

        $filename = $archivePath . '/' . $shiftData['id'] . '.json';
        file_put_contents($filename, json_encode($shiftData, JSON_PRETTY_PRINT));
    }
}

