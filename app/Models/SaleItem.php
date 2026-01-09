<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * SaleItem Model
 * 
 * Line items for sales with batch traceability (FEFO compliance).
 * Batch number denormalized for reporting even if stock_item is deleted.
 */
class SaleItem extends Model
{
    use HasFactory;

    protected $fillable = [
        'sale_id',
        'stock_item_id',
        'drug_id',
        'batch_number',
        'quantity',
        'quantity_returned',
        'unit_price',
        'subtotal',
        'vat_rate',
        'vat_amount',
    ];

    protected $casts = [
        'quantity' => 'integer',
        'quantity_returned' => 'integer',
        'unit_price' => 'decimal:2',
        'subtotal' => 'decimal:2',
        'vat_rate' => 'decimal:2',
        'vat_amount' => 'decimal:2',
    ];

    /**
     * Get the returnable quantity (quantity - quantity_returned).
     */
    public function getReturnableQuantityAttribute(): int
    {
        return $this->quantity - ($this->quantity_returned ?? 0);
    }

    /**
     * Check if this item can be returned.
     */
    public function canBeReturned(): bool
    {
        return $this->returnable_quantity > 0;
    }

    /**
     * Check if this item has been fully returned.
     */
    public function isFullyReturned(): bool
    {
        return $this->returnable_quantity === 0;
    }

    /**
     * Get the sale for this item.
     */
    public function sale(): BelongsTo
    {
        return $this->belongsTo(Sale::class);
    }

    /**
     * Get the stock item for this sale item.
     */
    public function stockItem(): BelongsTo
    {
        return $this->belongsTo(StockItem::class);
    }

    /**
     * Get the drug for this item.
     */
    public function drug(): BelongsTo
    {
        return $this->belongsTo(Drug::class);
    }
}

