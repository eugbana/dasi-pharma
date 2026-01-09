<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;

/**
 * StockItem Model
 * 
 * CRITICAL: Tracks specific batches of drugs at each branch.
 * Each batch is a separate record for precise expiry tracking and FEFO compliance.
 * quantity_available is updated via stock_movements, never directly.
 */
class StockItem extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = [
        'drug_id',
        'branch_id',
        'batch_number',
        'manufacturing_date',
        'expiry_date',
        'purchase_price',
        'selling_price',
        'vat_applicable',
        'quantity_available',
        'minimum_stock_level',
        'reorder_point',
    ];

    protected $casts = [
        'manufacturing_date' => 'date',
        'expiry_date' => 'date',
        'purchase_price' => 'decimal:2',
        'selling_price' => 'decimal:2',
        'vat_applicable' => 'boolean',
        'quantity_available' => 'integer',
        'minimum_stock_level' => 'integer',
        'reorder_point' => 'integer',
    ];

    /**
     * Get the drug for this stock item.
     */
    public function drug(): BelongsTo
    {
        return $this->belongsTo(Drug::class);
    }

    /**
     * Get the branch for this stock item.
     */
    public function branch(): BelongsTo
    {
        return $this->belongsTo(Branch::class);
    }

    /**
     * Get all stock movements for this item.
     */
    public function stockMovements(): HasMany
    {
        return $this->hasMany(StockMovement::class);
    }

    /**
     * Get all sale items from this stock item.
     */
    public function saleItems(): HasMany
    {
        return $this->hasMany(SaleItem::class);
    }

    /**
     * Check if stock item is expired.
     */
    public function isExpired(): bool
    {
        return $this->expiry_date < Carbon::today();
    }

    /**
     * Check if stock item is expiring soon (within days).
     */
    public function isExpiringSoon(int $days = 90): bool
    {
        return $this->expiry_date <= Carbon::today()->addDays($days) 
            && !$this->isExpired();
    }

    /**
     * Get days until expiry.
     */
    public function getDaysUntilExpiryAttribute(): int
    {
        return Carbon::today()->diffInDays($this->expiry_date, false);
    }

    /**
     * Check if stock is below minimum level.
     */
    public function isBelowMinimum(): bool
    {
        return $this->quantity_available < $this->minimum_stock_level;
    }

    /**
     * Check if stock has reached reorder point.
     */
    public function hasReachedReorderPoint(): bool
    {
        return $this->quantity_available <= $this->reorder_point;
    }

    /**
     * Calculate markup percentage.
     */
    public function getMarkupPercentageAttribute(): float
    {
        if ($this->purchase_price == 0) {
            return 0;
        }
        return (($this->selling_price - $this->purchase_price) / $this->purchase_price) * 100;
    }

    /**
     * Scope to get available stock (quantity > 0).
     */
    public function scopeAvailable($query)
    {
        return $query->where('quantity_available', '>', 0);
    }

    /**
     * Scope to get in-stock items (quantity > 0 and not expired).
     */
    public function scopeInStock($query)
    {
        return $query->where('quantity_available', '>', 0)
            ->where('expiry_date', '>=', Carbon::today());
    }

    /**
     * Scope to get out of stock items (quantity = 0).
     */
    public function scopeOutOfStock($query)
    {
        return $query->where('quantity_available', '=', 0);
    }

    /**
     * Scope to get expired stock.
     */
    public function scopeExpired($query)
    {
        return $query->where('expiry_date', '<', Carbon::today());
    }

    /**
     * Scope to get non-expired stock.
     */
    public function scopeNotExpired($query)
    {
        return $query->where('expiry_date', '>=', Carbon::today());
    }

    /**
     * Scope to get stock expiring soon.
     */
    public function scopeExpiringSoon($query, int $days = 90)
    {
        return $query->where('expiry_date', '<=', Carbon::today()->addDays($days))
            ->where('expiry_date', '>=', Carbon::today());
    }

    /**
     * Scope to get stock below minimum level.
     */
    public function scopeBelowMinimum($query)
    {
        return $query->whereColumn('quantity_available', '<', 'minimum_stock_level');
    }

    /**
     * Scope to get low stock items (at or below reorder point).
     */
    public function scopeLowStock($query)
    {
        return $query->whereColumn('quantity_available', '<=', 'reorder_point');
    }

    /**
     * Scope to get stock at reorder point.
     */
    public function scopeAtReorderPoint($query)
    {
        return $query->whereColumn('quantity_available', '<=', 'reorder_point');
    }

    /**
     * Scope for FEFO selection - First Expired, First Out.
     * Orders by expiry date ascending, then by created_at.
     */
    public function scopeFEFO($query)
    {
        return $query->orderBy('expiry_date', 'asc')
            ->orderBy('created_at', 'asc');
    }
}

