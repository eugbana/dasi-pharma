<?php

namespace App\Services;

use App\Models\User;
use Illuminate\Support\Facades\Log;

/**
 * Comprehensive audit logging service for POS desktop operations.
 * 
 * Logs all POS actions with full context for compliance and security.
 */
class POSAuditService
{
    protected string $hardwareId;
    protected ?User $currentUser = null;

    public function __construct()
    {
        $this->hardwareId = config('pos.hardware_id', 'UNKNOWN');
    }

    /**
     * Set the current user for audit context.
     */
    public function setUser(User $user): self
    {
        $this->currentUser = $user;
        return $this;
    }

    /**
     * Log a sale transaction.
     */
    public function logSale(array $saleData): void
    {
        $this->log('sale', 'Sale completed', [
            'invoice_number' => $saleData['invoice_number'] ?? null,
            'total_amount' => $saleData['total_amount'] ?? 0,
            'payment_method' => $saleData['payment_method'] ?? 'cash',
            'items_count' => count($saleData['items'] ?? []),
            'customer_id' => $saleData['customer_id'] ?? null,
            'has_prescription' => $saleData['has_prescription'] ?? false,
            'has_controlled_substance' => $saleData['has_controlled_substance'] ?? false,
        ]);
    }

    /**
     * Log a void transaction.
     */
    public function logVoid(string $invoiceNumber, string $reason, float $amount): void
    {
        $this->log('void', 'Transaction voided', [
            'invoice_number' => $invoiceNumber,
            'amount' => $amount,
            'reason' => $reason,
        ], 'warning');
    }

    /**
     * Log a return/refund.
     */
    public function logReturn(string $originalInvoice, array $returnData): void
    {
        $this->log('return', 'Return processed', [
            'original_invoice' => $originalInvoice,
            'return_amount' => $returnData['amount'] ?? 0,
            'items_returned' => count($returnData['items'] ?? []),
            'reason' => $returnData['reason'] ?? null,
        ]);
    }

    /**
     * Log cash drawer operations.
     */
    public function logCashDrawer(string $action, float $amount = 0, string $reason = ''): void
    {
        $this->log('cash_drawer', "Cash drawer {$action}", [
            'action' => $action,
            'amount' => $amount,
            'reason' => $reason,
        ]);
    }

    /**
     * Log shift operations.
     */
    public function logShift(string $action, array $shiftData): void
    {
        $this->log('shift', "Shift {$action}", [
            'shift_id' => $shiftData['id'] ?? null,
            'action' => $action,
            'cash_amount' => $shiftData['opening_cash'] ?? $shiftData['closing_cash'] ?? 0,
        ]);
    }

    /**
     * Log barcode scan events.
     */
    public function logBarcodeScan(string $barcode, bool $found, ?int $drugId = null): void
    {
        $this->log('barcode', 'Barcode scanned', [
            'barcode' => $barcode,
            'found' => $found,
            'drug_id' => $drugId,
        ], $found ? 'info' : 'warning');
    }

    /**
     * Log price override.
     */
    public function logPriceOverride(int $itemId, float $originalPrice, float $newPrice, string $reason): void
    {
        $this->log('price_override', 'Price override applied', [
            'item_id' => $itemId,
            'original_price' => $originalPrice,
            'new_price' => $newPrice,
            'discount_percent' => round((($originalPrice - $newPrice) / $originalPrice) * 100, 2),
            'reason' => $reason,
        ], 'warning');
    }

    /**
     * Log controlled substance sale.
     */
    public function logControlledSubstanceSale(array $data): void
    {
        $this->log('controlled_substance', 'Controlled substance sale', [
            'drug_id' => $data['drug_id'],
            'drug_name' => $data['drug_name'],
            'quantity' => $data['quantity'],
            'prescription_number' => $data['prescription_number'] ?? null,
            'prescriber' => $data['prescriber'] ?? null,
            'approved_by' => $data['approved_by'] ?? null,
        ], 'warning');
    }

    /**
     * Log sync operations.
     */
    public function logSync(string $action, array $stats): void
    {
        $this->log('sync', "Sync {$action}", [
            'action' => $action,
            'records_uploaded' => $stats['uploaded'] ?? 0,
            'records_downloaded' => $stats['downloaded'] ?? 0,
            'conflicts' => $stats['conflicts'] ?? 0,
            'duration_ms' => $stats['duration_ms'] ?? 0,
        ]);
    }

    /**
     * Log security events.
     */
    public function logSecurity(string $message, array $context = [], string $level = 'warning'): void
    {
        $this->log('security', $message, $context, $level);
    }

    /**
     * Core logging method.
     */
    protected function log(string $type, string $message, array $context = [], string $level = 'info'): void
    {
        $fullContext = array_merge($context, [
            'type' => $type,
            'hardware_id' => $this->hardwareId,
            'user_id' => $this->currentUser?->id,
            'user_name' => $this->currentUser?->name,
            'user_role' => $this->currentUser?->roles->first()?->name ?? 'unknown',
            'branch_id' => $this->currentUser?->branch_id,
            'timestamp' => now()->toIso8601String(),
            'timestamp_local' => now()->format('Y-m-d H:i:s'),
        ]);

        Log::channel('pos_audit')->{$level}($message, $fullContext);
    }
}

