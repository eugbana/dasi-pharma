<?php

namespace App\Http\Controllers;

use App\Models\Drug;
use App\Models\StockItem;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Picqer\Barcode\BarcodeGeneratorPNG;

class BarcodeController extends Controller
{
    /**
     * Generate barcode for a drug.
     */
    public function generate(Drug $drug): Response
    {
        $generator = new BarcodeGeneratorPNG();
        
        // Use existing barcode or drug ID
        $barcodeValue = $drug->barcode ?? str_pad($drug->id, 13, '0', STR_PAD_LEFT);
        
        // Generate Code128 barcode
        $barcode = $generator->getBarcode($barcodeValue, $generator::TYPE_CODE_128);
        
        return response($barcode, 200, [
            'Content-Type' => 'image/png',
            'Content-Disposition' => 'inline; filename="barcode-' . $drug->id . '.png"',
        ]);
    }

    /**
     * Generate barcode for a stock item.
     */
    public function generateForStock(StockItem $stockItem): Response
    {
        $generator = new BarcodeGeneratorPNG();
        
        // Use drug barcode or create composite barcode with batch
        $barcodeValue = $stockItem->drug->barcode ?? str_pad($stockItem->drug_id, 13, '0', STR_PAD_LEFT);
        
        $barcode = $generator->getBarcode($barcodeValue, $generator::TYPE_CODE_128);
        
        return response($barcode, 200, [
            'Content-Type' => 'image/png',
            'Content-Disposition' => 'inline; filename="barcode-stock-' . $stockItem->id . '.png"',
        ]);
    }

    /**
     * Lookup drug by barcode.
     */
    public function lookup(Request $request)
    {
        $validated = $request->validate([
            'barcode' => 'required|string',
            'branch_id' => 'nullable|exists:branches,id',
        ]);

        $branchId = $validated['branch_id'] ?? $request->user()->branch_id;

        // Find drug by barcode
        $drug = Drug::where('barcode', $validated['barcode'])->first();

        if (!$drug) {
            // Try to find by ID if barcode is numeric
            if (is_numeric($validated['barcode'])) {
                $drugId = (int) ltrim($validated['barcode'], '0');
                $drug = Drug::find($drugId);
            }
        }

        if (!$drug) {
            return response()->json([
                'success' => false,
                'message' => 'Drug not found',
            ], 404);
        }

        // Get available stock for this drug at the branch
        $stockItems = StockItem::where('drug_id', $drug->id)
            ->where('branch_id', $branchId)
            ->inStock()
            ->notExpired()
            ->with('drug:id,brand_name,strength,dosage_form,is_prescription_only')
            ->orderBy('expiry_date')
            ->get()
            ->map(function ($item) {
                return [
                    'id' => $item->id,
                    'batch_number' => $item->batch_number,
                    'expiry_date' => $item->expiry_date->format('Y-m-d'),
                    'quantity_available' => $item->quantity_available,
                    'selling_price' => $item->selling_price,
                    'days_until_expiry' => $item->days_until_expiry,
                ];
            });

        return response()->json([
            'success' => true,
            'drug' => [
                'id' => $drug->id,
                'brand_name' => $drug->brand_name,
                'generic_name' => $drug->generic_name,
                'strength' => $drug->strength,
                'dosage_form' => $drug->dosage_form,
                'is_prescription_only' => $drug->is_prescription_only,
                'barcode' => $drug->barcode,
            ],
            'stock_items' => $stockItems,
            'total_available' => $stockItems->sum('quantity_available'),
        ]);
    }

    /**
     * Generate barcode value for a drug.
     */
    public function generateBarcodeValue(Drug $drug): string
    {
        // If drug already has a barcode, return it
        if ($drug->barcode) {
            return $drug->barcode;
        }

        // Generate a unique barcode based on drug ID
        // Format: 8 (prefix) + 12 digits (padded drug ID)
        $barcodeValue = '8' . str_pad($drug->id, 12, '0', STR_PAD_LEFT);

        // Update drug with generated barcode
        $drug->update(['barcode' => $barcodeValue]);

        return $barcodeValue;
    }

    /**
     * Print barcode label for stock item.
     */
    public function printLabel(StockItem $stockItem)
    {
        $stockItem->load('drug:id,brand_name,strength,dosage_form,barcode');

        $generator = new BarcodeGeneratorPNG();
        $barcodeValue = $stockItem->drug->barcode ?? $this->generateBarcodeValue($stockItem->drug);
        $barcodeImage = base64_encode($generator->getBarcode($barcodeValue, $generator::TYPE_CODE_128));

        return response()->json([
            'drug' => [
                'brand_name' => $stockItem->drug->brand_name,
                'strength' => $stockItem->drug->strength,
                'dosage_form' => $stockItem->drug->dosage_form,
            ],
            'batch_number' => $stockItem->batch_number,
            'expiry_date' => $stockItem->expiry_date->format('M Y'),
            'selling_price' => $stockItem->selling_price,
            'barcode_value' => $barcodeValue,
            'barcode_image' => 'data:image/png;base64,' . $barcodeImage,
        ]);
    }
}

