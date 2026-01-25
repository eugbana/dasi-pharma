<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;

/**
 * Sale Model
 * 
 * Point-of-sale transactions with prescription tracking and pharmacist approval.
 */
class Sale extends Model
{
    use HasFactory, SoftDeletes;

    const STATUS_COMPLETED = 'completed';
    const STATUS_RETURNED = 'returned';
    const STATUS_PARTIALLY_RETURNED = 'partially_returned';

    protected $fillable = [
        'sale_number',
        'branch_id',
        'user_id',
        'sale_date',
        'subtotal',
        'tax_amount',
        'discount_amount',
        'discount_authorized_by',
        'total_amount',
        'customer_name',
        'customer_phone',
        'prescription_number',
        'approved_by_pharmacist',
        'status',
    ];

    protected $casts = [
        'sale_date' => 'datetime',
        'subtotal' => 'decimal:2',
        'tax_amount' => 'decimal:2',
        'discount_amount' => 'decimal:2',
        'total_amount' => 'decimal:2',
    ];

    /**
     * Get the branch for this sale.
     */
    public function branch(): BelongsTo
    {
        return $this->belongsTo(Branch::class);
    }

    /**
     * Get the user who processed this sale.
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Get the pharmacist who approved this sale.
     */
    public function pharmacist(): BelongsTo
    {
        return $this->belongsTo(User::class, 'approved_by_pharmacist');
    }

    /**
     * Get the user who authorized the discount for this sale.
     */
    public function discountAuthorizer(): BelongsTo
    {
        return $this->belongsTo(User::class, 'discount_authorized_by');
    }

    /**
     * Get all line items for this sale.
     */
    public function items(): HasMany
    {
        return $this->hasMany(SaleItem::class);
    }

    /**
     * Get all payments for this sale.
     */
    public function payments(): HasMany
    {
        return $this->hasMany(Payment::class);
    }

    /**
     * Get all returns for this sale.
     */
    public function returns(): HasMany
    {
        return $this->hasMany(SaleReturn::class);
    }

    /**
     * Check if sale has prescription.
     */
    public function hasPrescription(): bool
    {
        return !is_null($this->prescription_number);
    }

    /**
     * Check if sale can be returned.
     */
    public function canBeReturned(): bool
    {
        // Only completed sales can be returned
        if ($this->status === self::STATUS_RETURNED) {
            return false;
        }

        // Check if there are any returnable items
        return $this->items->some(fn($item) => $item->canBeReturned());
    }

    /**
     * Check if sale is within return window (configurable days).
     */
    public function isWithinReturnWindow(int $days = 30): bool
    {
        return $this->sale_date->diffInDays(now()) <= $days;
    }

    /**
     * Get total returnable amount.
     */
    public function getReturnableAmountAttribute(): float
    {
        return $this->items->sum(function ($item) {
            return $item->returnable_quantity * floatval($item->unit_price);
        });
    }

    /**
     * Check if sale was approved by pharmacist.
     */
    public function isPharmacistApproved(): bool
    {
        return !is_null($this->approved_by_pharmacist);
    }

    /**
     * Scope to filter by date range.
     */
    public function scopeDateRange($query, $startDate, $endDate)
    {
        return $query->whereBetween('sale_date', [$startDate, $endDate]);
    }

    /**
     * Scope to filter by status.
     */
    public function scopeByStatus($query, string $status)
    {
        return $query->where('status', $status);
    }

    /**
     * Scope to get completed sales.
     */
    public function scopeCompleted($query)
    {
        return $query->where('status', self::STATUS_COMPLETED);
    }

    /**
     * Scope to filter by customer phone.
     */
    public function scopeByCustomer($query, string $phone)
    {
        return $query->where('customer_phone', $phone);
    }
}

