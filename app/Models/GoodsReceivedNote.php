<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

/**
 * GoodsReceivedNote Model
 * 
 * Records actual receipt of goods from suppliers.
 * Supports partial deliveries and quality control workflow.
 */
class GoodsReceivedNote extends Model
{
    use HasFactory;

    const STATUS_PENDING_QUALITY_CHECK = 'pending_quality_check';
    const STATUS_APPROVED = 'approved';
    const STATUS_REJECTED = 'rejected';

    protected $fillable = [
        'grn_number',
        'purchase_order_id',
        'branch_id',
        'received_by',
        'received_date',
        'status',
        'notes',
    ];

    protected $casts = [
        'received_date' => 'date',
    ];

    /**
     * Get the purchase order for this GRN.
     */
    public function purchaseOrder(): BelongsTo
    {
        return $this->belongsTo(PurchaseOrder::class);
    }

    /**
     * Get the branch for this GRN.
     */
    public function branch(): BelongsTo
    {
        return $this->belongsTo(Branch::class);
    }

    /**
     * Get the user who received the goods.
     */
    public function receiver(): BelongsTo
    {
        return $this->belongsTo(User::class, 'received_by');
    }

    /**
     * Get all line items for this GRN.
     */
    public function items(): HasMany
    {
        return $this->hasMany(GoodsReceivedItem::class, 'grn_id');
    }

    /**
     * Scope to filter by status.
     */
    public function scopeByStatus($query, string $status)
    {
        return $query->where('status', $status);
    }

    /**
     * Scope to get pending quality check GRNs.
     */
    public function scopePendingQualityCheck($query)
    {
        return $query->where('status', self::STATUS_PENDING_QUALITY_CHECK);
    }
}

