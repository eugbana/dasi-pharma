<?php

namespace App\Services;

use App\Models\Sale;
use Illuminate\Support\Facades\Log;

/**
 * Thermal printer service for POS receipt printing.
 * 
 * Supports ESC/POS compatible thermal printers via USB or network.
 */
class ThermalPrinterService
{
    protected string $printerType;
    protected string $connection;
    protected ?string $port;
    protected int $paperWidth;
    protected bool $simulateMode;

    // ESC/POS Commands
    protected const ESC = "\x1B";
    protected const GS = "\x1D";
    protected const LF = "\x0A";
    protected const CUT = "\x1D\x56\x00";
    protected const DRAWER_KICK = "\x1B\x70\x00\x19\xFA";

    public function __construct(
        string $printerType = 'thermal',
        string $connection = 'usb',
        ?string $port = null
    ) {
        $this->printerType = $printerType;
        $this->connection = $connection;
        $this->port = $port;
        $this->paperWidth = config('pos-desktop.printer.paper_width', 80);
        $this->simulateMode = config('pos-desktop.testing.simulate_printer', false);
    }

    /**
     * Print a sale receipt.
     */
    public function printReceipt(Sale $sale): bool
    {
        $sale->load(['items.stockItem.drug', 'user', 'branch', 'customer']);

        $content = $this->buildReceiptContent($sale);
        
        return $this->sendToPrinter($content);
    }

    /**
     * Build receipt content for a sale.
     */
    protected function buildReceiptContent(Sale $sale): string
    {
        $lines = [];
        $width = $this->paperWidth === 80 ? 48 : 32;

        // Header - compact
        $lines[] = $this->center('DASI PHARMA', $width);
        $lines[] = $this->center($sale->branch->name ?? 'Main Branch', $width);
        if ($sale->branch?->address) {
            $lines[] = $this->center($sale->branch->address, $width);
        }
        $lines[] = str_repeat('-', $width);

        // Transaction info - single line for date/time
        $lines[] = $sale->created_at->format('d/m/Y H:i') . str_repeat(' ', $width - strlen($sale->created_at->format('d/m/Y H:i')) - strlen($sale->invoice_number)) . $sale->invoice_number;
        $lines[] = "Cashier: " . ($sale->user->name ?? 'Unknown');
        $lines[] = str_repeat('-', $width);

        // Items - compact format with product name and barcode
        foreach ($sale->items as $item) {
            $drug = $item->stockItem?->drug;
            $drugName = $drug?->brand_name ?? 'Unknown Item';
            $barcode = $drug?->barcode ?? '';

            // Product name (truncated if needed)
            $lines[] = substr($drugName, 0, $width);

            // Barcode and quantity x price = total on same line
            $barcodePrefix = $barcode ? "[{$barcode}] " : '';
            $qtyPrice = sprintf("%d x %.2f", $item->quantity, $item->unit_price);
            $total = sprintf("%.2f", $item->total_price);
            $itemDetail = $barcodePrefix . $qtyPrice;
            $lines[] = $itemDetail . str_repeat(' ', max(1, $width - strlen($itemDetail) - strlen($total))) . $total;
        }
        $lines[] = str_repeat('-', $width);

        // Totals - compact
        $lines[] = $this->formatLine('Subtotal:', number_format($sale->subtotal, 2), $width);
        if ($sale->discount_amount > 0) {
            $lines[] = $this->formatLine('Discount:', '-' . number_format($sale->discount_amount, 2), $width);
        }
        if ($sale->tax_amount > 0) {
            $lines[] = $this->formatLine('VAT (16%):', number_format($sale->tax_amount, 2), $width);
        }
        $lines[] = $this->formatLine('TOTAL:', number_format($sale->total_amount, 2), $width);

        // Payment info
        $lines[] = $this->formatLine('Payment:', ucfirst($sale->payment_method), $width);
        if ($sale->amount_tendered > 0) {
            $lines[] = $this->formatLine('Tendered:', number_format($sale->amount_tendered, 2), $width);
            $lines[] = $this->formatLine('Change:', number_format($sale->change_amount, 2), $width);
        }
        $lines[] = str_repeat('-', $width);

        // Footer - compact
        $lines[] = $this->center('Thank you for your purchase!', $width);
        if ($sale->user?->pharmacist_registration) {
            $lines[] = $this->center("Pharmacist: " . $sale->user->name . " [" . $sale->user->pharmacist_registration . "]", $width);
        }

        return implode(self::LF, $lines) . self::CUT;
    }

    /**
     * Open the cash drawer.
     */
    public function openDrawer(): bool
    {
        return $this->sendToPrinter(self::DRAWER_KICK);
    }

    /**
     * Send content to printer.
     */
    protected function sendToPrinter(string $content): bool
    {
        if ($this->simulateMode) {
            Log::channel('pos_desktop')->info('Simulated print', ['content_length' => strlen($content)]);
            return true;
        }

        try {
            // In production, this would use the appropriate driver
            // For now, we'll use file-based output for testing
            $outputPath = storage_path('pos/print_queue/' . uniqid('receipt_') . '.prn');
            
            if (!is_dir(dirname($outputPath))) {
                mkdir(dirname($outputPath), 0755, true);
            }
            
            file_put_contents($outputPath, $content);
            
            Log::channel('pos_desktop')->info('Receipt queued for printing', ['file' => $outputPath]);
            return true;
        } catch (\Exception $e) {
            Log::channel('pos_desktop')->error('Print failed', ['error' => $e->getMessage()]);
            return false;
        }
    }

    /**
     * Center text within width.
     */
    protected function center(string $text, int $width): string
    {
        $text = substr($text, 0, $width);
        $padding = ($width - strlen($text)) / 2;
        return str_repeat(' ', (int) $padding) . $text;
    }

    /**
     * Format a label: value line.
     */
    protected function formatLine(string $label, string $value, int $width): string
    {
        $spaces = $width - strlen($label) - strlen($value);
        return $label . str_repeat(' ', max(1, $spaces)) . $value;
    }
}

