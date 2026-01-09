<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\MorphTo;

/**
 * StockMovement Model
 * 
 * CRITICAL: Comprehensive audit trail of all inventory changes.
 * Every stock change must be recorded here with user, timestamp, and reason.
 * Polymorphic relationship to source transactions (sales, purchases, transfers).
 */
class StockMovement extends Model
{
    use HasFactory;

    const TYPE_PURCHASE = 'purchase';
    const TYPE_SALE = 'sale';
    const TYPE_TRANSFER_IN = 'transfer_in';
    const TYPE_TRANSFER_OUT = 'transfer_out';
    const TYPE_ADJUSTMENT = 'adjustment';
    const TYPE_EXPIRY = 'expiry';
    const TYPE_RETURN = 'return';

    protected $fillable = [
        'stock_item_id',
        'user_id',
        'movement_type',
        'quantity',
        'unit_cost',
        'reference_type',
        'reference_id',
        'reason',
        'movement_date',
    ];

    protected $casts = [
        'quantity' => 'integer',
        'unit_cost' => 'decimal:2',
        'movement_date' => 'date',
    ];

    /**
     * Get the stock item for this movement.
     */
    public function stockItem(): BelongsTo
    {
        return $this->belongsTo(StockItem::class);
    }

    /**
     * Get the user who performed this movement.
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Get the source transaction (polymorphic).
     */
    public function reference(): MorphTo
    {
        return $this->morphTo();
    }

    /**
     * Check if movement increases stock.
     */
    public function isIncrease(): bool
    {
        return $this->quantity > 0;
    }

    /**
     * Check if movement decreases stock.
     */
    public function isDecrease(): bool
    {
        return $this->quantity < 0;
    }

    /**
     * Get absolute quantity value.
     */
    public function getAbsoluteQuantityAttribute(): int
    {
        return abs($this->quantity);
    }

    /**
     * Scope to filter by movement type.
     */
    public function scopeByType($query, string $type)
    {
        return $query->where('movement_type', $type);
    }

    /**
     * Scope to filter by date range.
     */
    public function scopeDateRange($query, $startDate, $endDate)
    {
        return $query->whereBetween('movement_date', [$startDate, $endDate]);
    }

    /**
     * Scope to get increases only.
     */
    public function scopeIncreases($query)
    {
        return $query->where('quantity', '>', 0);
    }

    /**
     * Scope to get decreases only.
     */
    public function scopeDecreases($query)
    {
        return $query->where('quantity', '<', 0);
    }
}

