<?php

namespace App\Http\Controllers;

use App\Models\GoodsReceivedNote;
use App\Models\PurchaseOrder;
use App\Models\Sale;
use App\Models\SaleReturn;
use App\Models\StockItem;
use App\Models\StockMovement;
use App\Models\SystemConfig;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;
use Inertia\Response;

class ReportController extends Controller
{
    /**
     * Display sales report.
     */
    public function sales(Request $request): Response
    {
        $branchId = $request->user()->branch_id;

        $validated = $request->validate([
            'start_date' => 'nullable|date',
            'end_date' => 'nullable|date|after_or_equal:start_date',
            'period' => 'nullable|in:today,week,month,year,custom',
        ]);

        // Determine date range
        $period = $validated['period'] ?? 'month';

        // For custom period, use provided dates; otherwise calculate from period
        if ($period === 'custom' && isset($validated['start_date'])) {
            $startDate = Carbon::parse($validated['start_date'])->startOfDay();
            $endDate = isset($validated['end_date'])
                ? Carbon::parse($validated['end_date'])->endOfDay()
                : now()->endOfDay();
        } else {
            $startDate = $this->getStartDate($period);
            $endDate = now()->endOfDay();
        }

        // Sales summary with items sold count
        $salesSummary = Sale::where('branch_id', $branchId)
            ->whereBetween('sale_date', [$startDate, $endDate])
            ->completed()
            ->selectRaw('
                COUNT(*) as total_transactions,
                SUM(total_amount) as total_sales,
                AVG(total_amount) as average_transaction
            ')
            ->first();

        // Get total items sold
        $totalItemsSold = DB::table('sale_items')
            ->join('sales', 'sale_items.sale_id', '=', 'sales.id')
            ->where('sales.branch_id', $branchId)
            ->whereBetween('sales.sale_date', [$startDate, $endDate])
            ->where('sales.status', 'completed')
            ->sum('sale_items.quantity');

        // Payment method breakdown for summary cards
        $paymentTotals = DB::table('payments')
            ->join('sales', 'payments.sale_id', '=', 'sales.id')
            ->where('sales.branch_id', $branchId)
            ->whereBetween('sales.sale_date', [$startDate, $endDate])
            ->where('sales.status', 'completed')
            ->selectRaw("
                SUM(CASE WHEN payments.payment_method = 'cash' THEN payments.amount ELSE 0 END) as cash_sales,
                SUM(CASE WHEN payments.payment_method = 'card' THEN payments.amount ELSE 0 END) as card_sales,
                SUM(CASE WHEN payments.payment_method = 'bank_transfer' THEN payments.amount ELSE 0 END) as transfer_sales
            ")
            ->first();

        // Returns summary
        $returnsSummary = SaleReturn::where('branch_id', $branchId)
            ->whereBetween('return_date', [$startDate, $endDate])
            ->where('status', 'completed')
            ->selectRaw('
                COUNT(*) as total_returns,
                SUM(refund_amount) as total_refunded
            ')
            ->first();

        // Daily sales trend
        $dailySales = Sale::where('branch_id', $branchId)
            ->whereBetween('sale_date', [$startDate, $endDate])
            ->completed()
            ->selectRaw('DATE(sale_date) as date, SUM(total_amount) as total, COUNT(*) as count')
            ->groupBy('date')
            ->orderBy('date')
            ->get();

        // Top selling drugs
        $topDrugs = DB::table('sale_items')
            ->join('sales', 'sale_items.sale_id', '=', 'sales.id')
            ->join('drugs', 'sale_items.drug_id', '=', 'drugs.id')
            ->where('sales.branch_id', $branchId)
            ->whereBetween('sales.sale_date', [$startDate, $endDate])
            ->where('sales.status', 'completed')
            ->selectRaw('
                drugs.id,
                drugs.brand_name,
                drugs.strength,
                drugs.dosage_form,
                SUM(sale_items.quantity) as total_quantity,
                SUM(sale_items.subtotal) as total_revenue
            ')
            ->groupBy('drugs.id', 'drugs.brand_name', 'drugs.strength', 'drugs.dosage_form')
            ->orderByDesc('total_revenue')
            ->limit(10)
            ->get();

        // Get detailed sales transactions with returns
        $sales = Sale::where('branch_id', $branchId)
            ->with([
                'user:id,name',
                'items' => function ($query) {
                    $query->with('drug:id,brand_name,strength,dosage_form');
                },
                'payments',
                'returns' => function ($query) {
                    $query->with([
                        'processedBy:id,name',
                        'authorizedBy:id,name',
                        'items.saleItem.drug:id,brand_name,strength'
                    ]);
                }
            ])
            ->whereBetween('sale_date', [$startDate, $endDate])
            ->whereIn('status', ['completed', 'partially_returned', 'returned'])
            ->orderBy('sale_date', 'desc')
            ->limit(100)
            ->get()
            ->map(function ($sale) {
                $hasReturns = $sale->returns->isNotEmpty();
                $isFullReturn = $sale->status === 'returned';
                $isPartialReturn = $sale->status === 'partially_returned';

                return [
                    'id' => $sale->id,
                    'sale_number' => $sale->sale_number,
                    'sale_date' => $sale->sale_date->format('Y-m-d H:i'),
                    'customer_name' => $sale->customer_name ?? 'Walk-in',
                    'total_amount' => $sale->total_amount,
                    'status' => $sale->status,
                    'cashier' => $sale->user->name ?? 'N/A',
                    'items_count' => $sale->items->count(),
                    'payment_methods' => $sale->payments->pluck('payment_method')->unique()->values(),
                    'has_returns' => $hasReturns,
                    'is_full_return' => $isFullReturn,
                    'is_partial_return' => $isPartialReturn,
                    'returns' => $sale->returns->map(function ($return) {
                        return [
                            'id' => $return->id,
                            'return_number' => $return->return_number,
                            'return_date' => $return->return_date->format('Y-m-d H:i'),
                            'refund_amount' => $return->refund_amount,
                            'refund_method' => $return->refund_method,
                            'reason' => $return->reason,
                            'processed_by' => $return->processedBy->name ?? 'N/A',
                            'authorized_by' => $return->authorizedBy->name ?? 'N/A',
                            'items' => $return->items->map(function ($item) {
                                return [
                                    'drug_name' => $item->saleItem->drug->brand_name ?? 'N/A',
                                    'drug_strength' => $item->saleItem->drug->strength ?? '',
                                    'quantity' => $item->quantity,
                                    'unit_price' => $item->unit_price,
                                    'refund_amount' => $item->refund_amount,
                                ];
                            }),
                        ];
                    }),
                    'total_returned' => $sale->returns->sum('refund_amount'),
                    'net_amount' => $sale->total_amount - $sale->returns->sum('refund_amount'),
                ];
            });

        // Compile summary with all data
        $summary = [
            'total_transactions' => $salesSummary->total_transactions ?? 0,
            'total_sales' => $salesSummary->total_sales ?? 0,
            'average_transaction' => $salesSummary->average_transaction ?? 0,
            'total_items_sold' => $totalItemsSold ?? 0,
            'cash_sales' => $paymentTotals->cash_sales ?? 0,
            'card_sales' => $paymentTotals->card_sales ?? 0,
            'transfer_sales' => $paymentTotals->transfer_sales ?? 0,
            'total_returns' => $returnsSummary->total_returns ?? 0,
            'total_refunded' => $returnsSummary->total_refunded ?? 0,
            'net_sales' => ($salesSummary->total_sales ?? 0) - ($returnsSummary->total_refunded ?? 0),
        ];

        return Inertia::render('Reports/Sales', [
            'summary' => $summary,
            'dailySales' => $dailySales,
            'topDrugs' => $topDrugs,
            'sales' => $sales,
            'filters' => [
                'start_date' => $startDate->format('Y-m-d'),
                'end_date' => $endDate->format('Y-m-d'),
                'period' => $period,
            ],
        ]);
    }

    /**
     * Display inventory report.
     */
    public function inventory(Request $request): Response
    {
        $branchId = $request->user()->branch_id;

        // Stock value summary
        $stockValue = StockItem::where('branch_id', $branchId)
            ->selectRaw('
                COUNT(*) as total_items,
                SUM(quantity_available) as total_quantity,
                SUM(quantity_available * purchase_price) as purchase_value,
                SUM(quantity_available * selling_price) as selling_value
            ')
            ->first();

        // Stock status breakdown
        $stockStatus = [
            'in_stock' => StockItem::where('branch_id', $branchId)->inStock()->count(),
            'low_stock' => StockItem::where('branch_id', $branchId)->lowStock()->count(),
            'out_of_stock' => StockItem::where('branch_id', $branchId)->outOfStock()->count(),
            'expiring_soon' => StockItem::where('branch_id', $branchId)->expiringSoon(30)->count(),
            'expired' => StockItem::where('branch_id', $branchId)->expired()->count(),
        ];

        // Stock movements summary
        $movementsSummary = StockMovement::whereHas('stockItem', function ($query) use ($branchId) {
            $query->where('branch_id', $branchId);
        })
            ->whereBetween('created_at', [now()->subDays(30), now()])
            ->selectRaw('
                movement_type,
                COUNT(*) as count,
                SUM(quantity) as total_quantity
            ')
            ->groupBy('movement_type')
            ->get();

        // Low stock items
        $lowStockItems = StockItem::where('branch_id', $branchId)
            ->with('drug:id,brand_name,strength,dosage_form')
            ->lowStock()
            ->orderBy('quantity_available')
            ->limit(20)
            ->get()
            ->map(function ($item) {
                return [
                    'id' => $item->id,
                    'drug_name' => $item->drug->brand_name,
                    'strength' => $item->drug->strength,
                    'dosage_form' => $item->drug->dosage_form,
                    'batch_number' => $item->batch_number,
                    'quantity_available' => $item->quantity_available,
                    'reorder_point' => $item->reorder_point,
                    'minimum_stock_level' => $item->minimum_stock_level,
                ];
            });

        return Inertia::render('Reports/Inventory', [
            'stockValue' => $stockValue,
            'stockStatus' => $stockStatus,
            'movementsSummary' => $movementsSummary,
            'lowStockItems' => $lowStockItems,
        ]);
    }

    /**
     * Display procurement report.
     */
    public function procurement(Request $request): Response
    {
        $branchId = $request->user()->branch_id;

        $validated = $request->validate([
            'start_date' => 'nullable|date',
            'end_date' => 'nullable|date|after_or_equal:start_date',
            'period' => 'nullable|in:today,week,month,year',
        ]);

        $period = $validated['period'] ?? 'month';
        $startDate = $validated['start_date'] ?? $this->getStartDate($period);
        $endDate = $validated['end_date'] ?? now();

        // Purchase orders summary
        $poSummary = PurchaseOrder::where('branch_id', $branchId)
            ->whereBetween('order_date', [$startDate, $endDate])
            ->selectRaw("
                COUNT(*) as total_orders,
                SUM(total_amount) as total_value,
                SUM(CASE WHEN status = 'approved' THEN total_amount ELSE 0 END) as approved_value,
                SUM(CASE WHEN status = 'completed' THEN total_amount ELSE 0 END) as completed_value,
                COUNT(CASE WHEN status = 'pending_approval' THEN 1 END) as pending_count,
                COUNT(CASE WHEN status = 'approved' THEN 1 END) as approved_count,
                COUNT(CASE WHEN status = 'completed' THEN 1 END) as completed_count
            ")
            ->first();

        // GRN summary
        $grnSummary = GoodsReceivedNote::where('branch_id', $branchId)
            ->whereBetween('received_date', [$startDate, $endDate])
            ->selectRaw("
                COUNT(*) as total_grns,
                COUNT(CASE WHEN status = 'approved' THEN 1 END) as approved_count,
                COUNT(CASE WHEN status = 'rejected' THEN 1 END) as rejected_count,
                COUNT(CASE WHEN status = 'pending_quality_check' THEN 1 END) as pending_count
            ")
            ->first();

        // Top suppliers by value
        $topSuppliers = PurchaseOrder::join('suppliers', 'purchase_orders.supplier_id', '=', 'suppliers.id')
            ->where('purchase_orders.branch_id', $branchId)
            ->whereBetween('purchase_orders.order_date', [$startDate, $endDate])
            ->whereIn('purchase_orders.status', ['approved', 'completed', 'partially_received'])
            ->selectRaw('
                suppliers.id,
                suppliers.name,
                COUNT(purchase_orders.id) as order_count,
                SUM(purchase_orders.total_amount) as total_value
            ')
            ->groupBy('suppliers.id', 'suppliers.name')
            ->orderByDesc('total_value')
            ->limit(10)
            ->get();

        // Monthly procurement trend
        $monthlyTrend = PurchaseOrder::where('branch_id', $branchId)
            ->whereBetween('order_date', [now()->subMonths(12), now()])
            ->selectRaw('
                strftime("%Y-%m", order_date) as month,
                COUNT(*) as order_count,
                SUM(total_amount) as total_value
            ')
            ->groupBy('month')
            ->orderBy('month')
            ->get();

        return Inertia::render('Reports/Procurement', [
            'poSummary' => $poSummary,
            'grnSummary' => $grnSummary,
            'topSuppliers' => $topSuppliers,
            'monthlyTrend' => $monthlyTrend,
            'filters' => [
                'start_date' => $startDate,
                'end_date' => $endDate,
                'period' => $period,
            ],
        ]);
    }

    /**
     * Export sales report to CSV.
     */
    public function exportSales(Request $request)
    {
        $branchId = $request->user()->branch_id;

        $validated = $request->validate([
            'start_date' => 'required|date',
            'end_date' => 'required|date|after_or_equal:start_date',
        ]);

        $sales = Sale::where('branch_id', $branchId)
            ->with(['user:id,name', 'items.drug:id,brand_name,strength', 'payments'])
            ->whereBetween('sale_date', [$validated['start_date'], $validated['end_date']])
            ->completed()
            ->orderBy('sale_date', 'desc')
            ->get();

        $filename = 'sales_report_' . now()->format('Y-m-d_His') . '.csv';

        $headers = [
            'Content-Type' => 'text/csv',
            'Content-Disposition' => "attachment; filename=\"$filename\"",
        ];

        $callback = function () use ($sales) {
            $file = fopen('php://output', 'w');

            // Header row
            fputcsv($file, [
                'Sale Number',
                'Date',
                'Customer',
                'Items',
                'Total Amount',
                'Payment Methods',
                'Cashier',
            ]);

            // Data rows
            foreach ($sales as $sale) {
                $paymentMethods = $sale->payments->pluck('payment_method')->unique()->map(function($method) {
                    return ucfirst($method);
                })->join(', ');

                fputcsv($file, [
                    $sale->sale_number,
                    $sale->sale_date->format('Y-m-d H:i'),
                    $sale->customer_name ?? 'Walk-in',
                    $sale->items->count(),
                    $sale->total_amount,
                    $paymentMethods ?: 'N/A',
                    $sale->user->name,
                ]);
            }

            fclose($file);
        };

        return response()->stream($callback, 200, $headers);
    }

    /**
     * Generate return receipt.
     */
    public function returnReceipt(SaleReturn $saleReturn): Response
    {
        $saleReturn->load([
            'sale' => function ($query) {
                $query->with(['user:id,name', 'branch:id,name,address,phone']);
            },
            'processedBy:id,name',
            'authorizedBy:id,name',
            'branch:id,name,address,phone',
            'items' => function ($query) {
                $query->with([
                    'saleItem.drug:id,brand_name,strength,dosage_form',
                    'stockItem:id,batch_number'
                ]);
            }
        ]);

        // Determine return type
        $originalTotal = $saleReturn->sale->total_amount;
        $refundAmount = $saleReturn->refund_amount;
        $returnType = $refundAmount >= $originalTotal ? 'Full Return' : 'Partial Return';

        // Get receipt configuration
        $receiptConfig = SystemConfig::getReceiptConfig();

        return Inertia::render('Reports/ReturnReceipt', [
            'returnData' => [
                'return_number' => $saleReturn->return_number,
                'return_date' => $saleReturn->return_date->format('Y-m-d H:i:s'),
                'return_type' => $returnType,
                'refund_amount' => $saleReturn->refund_amount,
                'refund_method' => ucfirst(str_replace('_', ' ', $saleReturn->refund_method)),
                'reason' => $saleReturn->reason,
                'status' => $saleReturn->status,
                'processed_by' => $saleReturn->processedBy->name ?? 'N/A',
                'authorized_by' => $saleReturn->authorizedBy->name ?? 'N/A',
                'original_sale' => [
                    'sale_number' => $saleReturn->sale->sale_number,
                    'sale_date' => $saleReturn->sale->sale_date->format('Y-m-d H:i:s'),
                    'total_amount' => $saleReturn->sale->total_amount,
                    'customer_name' => $saleReturn->sale->customer_name ?? 'Walk-in',
                    'cashier' => $saleReturn->sale->user->name ?? 'N/A',
                ],
                'branch' => [
                    'name' => $saleReturn->branch->name ?? 'N/A',
                    'address' => $saleReturn->branch->address ?? '',
                    'phone' => $saleReturn->branch->phone ?? '',
                ],
                'items' => $saleReturn->items->map(function ($item) {
                    return [
                        'drug_name' => $item->saleItem->drug->brand_name ?? 'N/A',
                        'strength' => $item->saleItem->drug->strength ?? '',
                        'dosage_form' => $item->saleItem->drug->dosage_form ?? '',
                        'batch_number' => $item->stockItem->batch_number ?? 'N/A',
                        'quantity' => $item->quantity,
                        'unit_price' => $item->unit_price,
                        'refund_amount' => $item->refund_amount,
                    ];
                }),
            ],
            'receiptConfig' => $receiptConfig,
        ]);
    }

    /**
     * Get start date based on period.
     */
    private function getStartDate(string $period): Carbon
    {
        return match ($period) {
            'today' => now()->startOfDay(),
            'week' => now()->startOfWeek(),
            'month' => now()->startOfMonth(),
            'year' => now()->startOfYear(),
            default => now()->startOfMonth(),
        };
    }
}


