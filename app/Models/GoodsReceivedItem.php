<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * GoodsReceivedItem Model
 * 
 * Line items for GRN with batch details.
 * Creates stock_item and stock_movement when quality check passes.
 */
class GoodsReceivedItem extends Model
{
    use HasFactory;

    protected $fillable = [
        'grn_id',
        'drug_id',
        'batch_number',
        'manufacturing_date',
        'expiry_date',
        'quantity_received',
        'unit_price',
        'quality_check_passed',
        'quality_notes',
    ];

    protected $casts = [
        'manufacturing_date' => 'date',
        'expiry_date' => 'date',
        'quantity_received' => 'integer',
        'unit_price' => 'decimal:2',
        'quality_check_passed' => 'boolean',
    ];

    /**
     * Get the GRN for this item.
     */
    public function goodsReceivedNote(): BelongsTo
    {
        return $this->belongsTo(GoodsReceivedNote::class, 'grn_id');
    }

    /**
     * Get the drug for this item.
     */
    public function drug(): BelongsTo
    {
        return $this->belongsTo(Drug::class);
    }
}

