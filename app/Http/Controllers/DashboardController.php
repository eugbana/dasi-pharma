<?php

namespace App\Http\Controllers;

use App\Models\Drug;
use App\Models\PurchaseOrder;
use App\Models\Sale;
use App\Models\StockItem;
use App\Models\StockTransfer;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;
use Inertia\Response;

class DashboardController extends Controller
{
    /**
     * Display the dashboard.
     */
    public function index(Request $request): Response
    {
        $user = $request->user();
        $branchId = $user->branch_id;

        // Get key metrics
        $metrics = [
            'total_drugs' => Drug::count(),
            'low_stock_items' => StockItem::where('branch_id', $branchId)
                ->lowStock()
                ->count(),
            'expiring_soon' => StockItem::where('branch_id', $branchId)
                ->expiringSoon(30)
                ->count(),
            'expired_items' => StockItem::where('branch_id', $branchId)
                ->expired()
                ->count(),
            'pending_transfers' => StockTransfer::where(function ($query) use ($branchId) {
                $query->where('from_branch_id', $branchId)
                    ->orWhere('to_branch_id', $branchId);
            })
                ->pending()
                ->count(),
            'today_sales' => Sale::where('branch_id', $branchId)
                ->whereDate('sale_date', today())
                ->completed()
                ->sum('total_amount'),
            'today_transactions' => Sale::where('branch_id', $branchId)
                ->whereDate('sale_date', today())
                ->completed()
                ->count(),
        ];

        // Get recent sales
        $recentSales = Sale::where('branch_id', $branchId)
            ->with(['user:id,name', 'items.drug:id,brand_name'])
            ->latest('sale_date')
            ->take(5)
            ->get()
            ->map(function ($sale) {
                return [
                    'id' => $sale->id,
                    'sale_number' => $sale->sale_number,
                    'customer_name' => $sale->customer_name,
                    'total_amount' => $sale->total_amount,
                    'sale_date' => $sale->sale_date->format('Y-m-d H:i'),
                    'user' => $sale->user->name,
                    'items_count' => $sale->items->count(),
                ];
            });

        // Get expiring items
        $expiringItems = StockItem::where('branch_id', $branchId)
            ->with('drug:id,brand_name,strength,dosage_form')
            ->expiringSoon(30)
            ->orderBy('expiry_date')
            ->take(10)
            ->get()
            ->map(function ($item) {
                return [
                    'id' => $item->id,
                    'drug_name' => $item->drug->brand_name,
                    'strength' => $item->drug->strength,
                    'dosage_form' => $item->drug->dosage_form,
                    'batch_number' => $item->batch_number,
                    'expiry_date' => $item->expiry_date->format('Y-m-d'),
                    'days_until_expiry' => $item->days_until_expiry,
                    'quantity_available' => $item->quantity_available,
                ];
            });

        // Sales trend (last 7 days)
        $salesTrend = Sale::where('branch_id', $branchId)
            ->whereBetween('sale_date', [now()->subDays(6)->startOfDay(), now()->endOfDay()])
            ->completed()
            ->selectRaw('DATE(sale_date) as date, SUM(total_amount) as total, COUNT(*) as count')
            ->groupBy('date')
            ->orderBy('date')
            ->get()
            ->map(function ($item) {
                return [
                    'date' => $item->date,
                    'total' => (float) $item->total,
                    'count' => $item->count,
                ];
            });

        // Top selling drugs (last 30 days)
        $topDrugs = DB::table('sale_items')
            ->join('sales', 'sale_items.sale_id', '=', 'sales.id')
            ->join('drugs', 'sale_items.drug_id', '=', 'drugs.id')
            ->where('sales.branch_id', $branchId)
            ->where('sales.status', 'completed')
            ->whereBetween('sales.sale_date', [now()->subDays(30), now()])
            ->selectRaw('drugs.brand_name, SUM(sale_items.quantity) as total_quantity, SUM(sale_items.subtotal) as total_revenue')
            ->groupBy('drugs.id', 'drugs.brand_name')
            ->orderByDesc('total_revenue')
            ->limit(5)
            ->get();

        // Procurement metrics
        $procurementMetrics = [
            'pending_pos' => PurchaseOrder::where('branch_id', $branchId)
                ->where('status', 'pending_approval')
                ->count(),
            'approved_pos' => PurchaseOrder::where('branch_id', $branchId)
                ->where('status', 'approved')
                ->count(),
        ];

        return Inertia::render('Dashboard/Index', [
            'metrics' => array_merge($metrics, $procurementMetrics),
            'recentSales' => $recentSales,
            'expiringItems' => $expiringItems,
            'salesTrend' => $salesTrend,
            'topDrugs' => $topDrugs,
        ]);
    }
}

