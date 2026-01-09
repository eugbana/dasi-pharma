<?php

namespace App\Http\Controllers;

use App\Models\SystemConfig;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class SystemConfigController extends Controller
{
    /**
     * Display the system configuration page.
     */
    public function index(): Response
    {
        $configs = SystemConfig::all()->groupBy('group');
        
        return Inertia::render('Admin/SystemConfig', [
            'configs' => $configs,
            'receiptConfig' => [
                'receipt_business_name' => SystemConfig::get('receipt_business_name', ''),
                'receipt_header_title' => SystemConfig::get('receipt_header_title', 'SALES RECEIPT'),
                'receipt_footer_message' => SystemConfig::get('receipt_footer_message', 'Thank you for your business'),
            ],
            'taxConfig' => [
                'vat_rate' => SystemConfig::get('vat_rate', 0),
                'vat_display_text' => SystemConfig::get('vat_display_text', 'VAT'),
            ],
        ]);
    }

    /**
     * Update system configurations.
     */
    public function update(Request $request)
    {
        $validated = $request->validate([
            'receipt_business_name' => 'nullable|string|max:255',
            'receipt_header_title' => 'nullable|string|max:100',
            'receipt_footer_message' => 'nullable|string|max:500',
            'vat_rate' => 'nullable|numeric|min:0|max:100',
            'vat_display_text' => 'nullable|string|max:50',
        ]);

        foreach ($validated as $key => $value) {
            SystemConfig::set($key, $value ?? '');
        }

        return redirect()->back()->with('success', 'System configuration updated successfully.');
    }

    /**
     * Get VAT rate via API.
     */
    public function getVatRate()
    {
        return response()->json([
            'vat_rate' => SystemConfig::getVatRate(),
            'vat_display_text' => SystemConfig::get('vat_display_text', 'VAT'),
        ]);
    }

    /**
     * Get receipt configuration via API.
     */
    public function getReceiptConfig()
    {
        return response()->json(SystemConfig::getReceiptConfig());
    }
}

