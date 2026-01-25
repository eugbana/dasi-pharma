<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;

/**
 * Drug Model
 * 
 * Master catalog of pharmaceutical products.
 * Includes regulatory compliance fields (NAFDAC, controlled substances).
 */
class Drug extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = [
        'brand_name',
        'generic_name',
        'strength',
        'dosage_form',
        'manufacturer',
        'barcode',
        'category_id',
        'subcategory_id',
        'is_prescription_only',
        'controlled_substance_class',
        'description',
    ];

    protected $casts = [
        'is_prescription_only' => 'boolean',
    ];

    /**
     * Get the category for this drug.
     */
    public function category(): BelongsTo
    {
        return $this->belongsTo(Category::class);
    }

    /**
     * Get the subcategory for this drug.
     */
    public function subcategory(): BelongsTo
    {
        return $this->belongsTo(Subcategory::class);
    }

    /**
     * Get all stock items for this drug.
     */
    public function stockItems(): HasMany
    {
        return $this->hasMany(StockItem::class);
    }

    /**
     * Get all sale items for this drug.
     */
    public function saleItems(): HasMany
    {
        return $this->hasMany(SaleItem::class);
    }

    /**
     * Get all purchase order items for this drug.
     */
    public function purchaseOrderItems(): HasMany
    {
        return $this->hasMany(PurchaseOrderItem::class);
    }

    /**
     * Check if drug is a controlled substance.
     */
    public function isControlledSubstance(): bool
    {
        return !is_null($this->controlled_substance_class);
    }

    /**
     * Check if drug requires prescription.
     */
    public function requiresPrescription(): bool
    {
        return $this->is_prescription_only || $this->isControlledSubstance();
    }

    /**
     * Get full drug name with strength and form.
     */
    public function getFullNameAttribute(): string
    {
        return "{$this->brand_name} {$this->strength} ({$this->dosage_form})";
    }

    /**
     * Scope to search drugs by name (brand or generic).
     */
    public function scopeSearch($query, string $search)
    {
        return $query->where(function ($q) use ($search) {
            $q->where('brand_name', 'like', "%{$search}%")
              ->orWhere('generic_name', 'like', "%{$search}%");
        });
    }

    /**
     * Scope to filter prescription-only drugs.
     */
    public function scopePrescriptionOnly($query)
    {
        return $query->where('is_prescription_only', true);
    }

    /**
     * Scope to filter controlled substances.
     */
    public function scopeControlledSubstances($query)
    {
        return $query->whereNotNull('controlled_substance_class');
    }

    /**
     * Scope to get available stock across all branches.
     */
    public function scopeWithAvailableStock($query)
    {
        return $query->withSum(['stockItems' => function ($q) {
            $q->where('quantity_available', '>', 0);
        }], 'quantity_available');
    }

    /**
     * Scope to filter active (non-deleted) drugs.
     */
    public function scopeActive($query)
    {
        return $query->whereNull('deleted_at');
    }

    /**
     * Get the display name for the drug.
     * Alias for brand_name to maintain compatibility.
     */
    public function getNameAttribute(): string
    {
        return $this->brand_name;
    }
}

