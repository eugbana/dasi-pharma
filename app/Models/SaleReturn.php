<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

/**
 * SaleReturn Model
 * 
 * Tracks return/refund transactions with admin authorization audit trail.
 */
class SaleReturn extends Model
{
    use HasFactory;

    const REFUND_CASH = 'cash';
    const REFUND_ORIGINAL = 'original_payment';
    const REFUND_STORE_CREDIT = 'store_credit';

    const STATUS_COMPLETED = 'completed';
    const STATUS_VOIDED = 'voided';

    protected $fillable = [
        'return_number',
        'sale_id',
        'branch_id',
        'processed_by',
        'authorized_by',
        'return_date',
        'refund_amount',
        'refund_method',
        'reason',
        'status',
    ];

    protected $casts = [
        'return_date' => 'datetime',
        'refund_amount' => 'decimal:2',
    ];

    /**
     * Get the original sale.
     */
    public function sale(): BelongsTo
    {
        return $this->belongsTo(Sale::class);
    }

    /**
     * Get the branch where return was processed.
     */
    public function branch(): BelongsTo
    {
        return $this->belongsTo(Branch::class);
    }

    /**
     * Get the staff who processed the return.
     */
    public function processedBy(): BelongsTo
    {
        return $this->belongsTo(User::class, 'processed_by');
    }

    /**
     * Get the admin who authorized the return.
     */
    public function authorizedBy(): BelongsTo
    {
        return $this->belongsTo(User::class, 'authorized_by');
    }

    /**
     * Get all return items.
     */
    public function items(): HasMany
    {
        return $this->hasMany(SaleReturnItem::class);
    }

    /**
     * Generate unique return number.
     */
    public static function generateReturnNumber(): string
    {
        $date = now();
        $prefix = 'RET-' . $date->format('Ymd');

        $lastReturn = self::where('return_number', 'like', "{$prefix}%")
            ->orderBy('return_number', 'desc')
            ->first();

        if ($lastReturn) {
            $lastNumber = (int) substr($lastReturn->return_number, -4);
            $newNumber = $lastNumber + 1;
        } else {
            $newNumber = 1;
        }

        return $prefix . '-' . str_pad($newNumber, 4, '0', STR_PAD_LEFT);
    }
}

