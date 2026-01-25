<?php

namespace App\Http\Controllers;

use App\Models\Sale;
use App\Models\SaleItem;
use App\Models\SaleReturn;
use App\Models\SaleReturnItem;
use App\Models\Payment;
use App\Models\StockItem;
use App\Models\StockMovement;
use App\Models\SystemConfig;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Inertia\Inertia;
use Inertia\Response;

/**
 * SaleController
 * 
 * Handles Point of Sale (POS) operations with FEFO logic,
 * prescription validation, and payment processing.
 */
class SaleController extends Controller
{
    /**
     * Display a listing of sales.
     */
    public function index(Request $request): Response
    {
        $branchId = $request->user()->branch_id;

        $query = Sale::with(['user:id,name', 'items', 'payments'])
            ->where('branch_id', $branchId);

        // Search filter
        if ($request->filled('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('sale_number', 'like', "%{$search}%")
                    ->orWhere('customer_name', 'like', "%{$search}%")
                    ->orWhere('customer_phone', 'like', "%{$search}%")
                    ->orWhere('prescription_number', 'like', "%{$search}%");
            });
        }

        // Status filter
        if ($request->filled('status')) {
            $query->byStatus($request->status);
        }

        // Date range filter - handle both dates or individual dates
        if ($request->filled('date_from') && $request->filled('date_to')) {
            // Both dates provided - use date range with full day coverage
            $startDate = $request->date_from . ' 00:00:00';
            $endDate = $request->date_to . ' 23:59:59';
            $query->dateRange($startDate, $endDate);
        } elseif ($request->filled('date_from')) {
            // Only start date provided - filter from start date onwards
            $query->where('sale_date', '>=', $request->date_from . ' 00:00:00');
        } elseif ($request->filled('date_to')) {
            // Only end date provided - filter up to end date
            $query->where('sale_date', '<=', $request->date_to . ' 23:59:59');
        }

        // User filter
        if ($request->filled('user_id')) {
            $query->where('user_id', $request->user_id);
        }

        // Sorting
        $sortBy = $request->get('sort_by', 'sale_date');
        $sortOrder = $request->get('sort_order', 'desc');
        $query->orderBy($sortBy, $sortOrder);

        $sales = $query->paginate(20)->withQueryString();

        // Transform sales data
        $sales->getCollection()->transform(function ($sale) {
            return [
                'id' => $sale->id,
                'sale_number' => $sale->sale_number,
                'sale_date' => $sale->sale_date->format('Y-m-d H:i'),
                'customer_name' => $sale->customer_name ?? 'Walk-in Customer',
                'customer_phone' => $sale->customer_phone,
                'total_amount' => $sale->total_amount,
                'status' => $sale->status,
                'items_count' => $sale->items->count(),
                'payment_methods' => $sale->payments->pluck('payment_method')->unique()->values(),
                'user' => $sale->user->name,
                'has_prescription' => $sale->hasPrescription(),
            ];
        });

        // Get users from current branch for the filter dropdown
        $users = User::where('branch_id', $branchId)
            ->where('is_active', true)
            ->orderBy('name')
            ->get(['id', 'name']);

        return Inertia::render('Sales/Index', [
            'sales' => $sales,
            'filters' => $request->only(['search', 'status', 'date_from', 'date_to', 'user_id']),
            'statuses' => [
                Sale::STATUS_COMPLETED => 'Completed',
                Sale::STATUS_RETURNED => 'Returned',
                Sale::STATUS_PARTIALLY_RETURNED => 'Partially Returned',
            ],
            'users' => $users,
        ]);
    }

    /**
     * Show the POS interface for creating a new sale.
     */
    public function create(Request $request): Response
    {
        $branchId = $request->user()->branch_id;

        // Get VAT configuration
        $vatRate = SystemConfig::getVatRate();

        // Get available stock items with FEFO ordering
        $stockItems = StockItem::with('drug')
            ->where('branch_id', $branchId)
            ->available()
            ->FEFO()
            ->get()
            ->map(function ($item) {
                return [
                    'id' => $item->id,
                    'drug_id' => $item->drug_id,
                    'drug_name' => $item->drug->name,
                    'generic_name' => $item->drug->generic_name,
                    'strength' => $item->drug->strength,
                    'dosage_form' => $item->drug->dosage_form,
                    'batch_number' => $item->batch_number,
                    'expiry_date' => $item->expiry_date->format('Y-m-d'),
                    'quantity_available' => $item->quantity_available,
                    'selling_price' => $item->selling_price,
                    'vat_applicable' => $item->vat_applicable,
                    'is_prescription_only' => $item->drug->is_prescription_only,
                    'controlled_substance_class' => $item->drug->controlled_substance_class,
                    'requires_prescription' => $item->drug->requiresPrescription(),
                ];
            });

        // Payment methods
        $paymentMethods = [
            Payment::METHOD_CASH => 'Cash',
            Payment::METHOD_CARD => 'Card',
            Payment::METHOD_TRANSFER => 'Bank Transfer',
            Payment::METHOD_MOBILE_MONEY => 'Mobile Money',
        ];

        // VAT configuration
        $vatConfig = [
            'rate' => $vatRate,
            'display_text' => SystemConfig::get('vat_display_text', 'VAT'),
        ];

        return Inertia::render('Sales/Create', [
            'stockItems' => $stockItems,
            'paymentMethods' => $paymentMethods,
            'vatConfig' => $vatConfig,
        ]);
    }

    /**
     * Store a newly created sale.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'sale_date' => 'required|date',
            'customer_name' => 'nullable|string|max:255',
            'customer_phone' => 'nullable|string|max:20',
            'prescription_number' => 'nullable|string|max:100',
            'discount_amount' => 'nullable|numeric|min:0',
            'discount_authorized_by' => 'nullable|exists:users,id',
            'items' => 'required|array|min:1',
            'items.*.stock_item_id' => 'required|exists:stock_items,id',
            'items.*.quantity' => 'required|integer|min:1',
            'payments' => 'required|array|min:1',
            'payments.*.payment_method' => 'required|in:cash,card,transfer,mobile_money',
            'payments.*.amount' => 'required|numeric|min:0.01',
            'payments.*.reference_number' => 'nullable|string|max:100',
        ]);

        DB::beginTransaction();

        try {
            $branchId = $request->user()->branch_id;
            $userId = $request->user()->id;

            // Check if prescription is required
            $requiresPrescription = false;
            $requiresPharmacistApproval = false;

            foreach ($validated['items'] as $item) {
                $stockItem = StockItem::with('drug')->findOrFail($item['stock_item_id']);

                // Verify stock availability
                if ($stockItem->quantity_available < $item['quantity']) {
                    throw new \Exception("Insufficient stock for {$stockItem->drug->name}. Available: {$stockItem->quantity_available}");
                }

                // Check prescription requirements
                if ($stockItem->drug->requiresPrescription()) {
                    $requiresPrescription = true;
                }

                if ($stockItem->drug->isControlledSubstance()) {
                    $requiresPharmacistApproval = true;
                }
            }

            // Validate prescription if required
            if ($requiresPrescription && empty($validated['prescription_number'])) {
                throw new \Exception('Prescription number is required for prescription-only medications.');
            }

            // Validate discount authorization if a discount is being applied
            $discountAuthorizedBy = null;
            $discountAmount = $validated['discount_amount'] ?? 0;
            if ($discountAmount > 0) {
                if (empty($validated['discount_authorized_by'])) {
                    throw new \Exception('Discount authorization is required when applying a discount.');
                }

                // Verify the authorizing user has permission
                $authorizer = User::with('role.permissions')->find($validated['discount_authorized_by']);
                if (!$authorizer || !$authorizer->is_active) {
                    throw new \Exception('Invalid discount authorization.');
                }

                $hasDiscountPermission = $authorizer->role && (
                    in_array(strtolower($authorizer->role->name), ['super admin', 'admin', 'manager', 'pharmacist']) ||
                    $authorizer->role->permissions->contains('name', 'sales.apply_discount') ||
                    $authorizer->can_authorize
                );

                if (!$hasDiscountPermission) {
                    throw new \Exception('Authorizing user does not have permission to approve discounts.');
                }

                $discountAuthorizedBy = $authorizer->id;
            }

            // Get VAT rate from system config
            $vatRate = SystemConfig::getVatRate();

            // Calculate totals with VAT
            $subtotal = 0;
            $taxAmount = 0;
            $itemsWithVat = [];

            foreach ($validated['items'] as $item) {
                $stockItem = StockItem::findOrFail($item['stock_item_id']);
                $itemSubtotal = $stockItem->selling_price * $item['quantity'];
                $subtotal += $itemSubtotal;

                // Calculate VAT for this item if applicable
                $itemVatRate = 0;
                $itemVatAmount = 0;
                if ($stockItem->vat_applicable && $vatRate > 0) {
                    $itemVatRate = $vatRate;
                    $itemVatAmount = round($itemSubtotal * ($vatRate / 100), 2);
                    $taxAmount += $itemVatAmount;
                }

                $itemsWithVat[$item['stock_item_id']] = [
                    'vat_rate' => $itemVatRate,
                    'vat_amount' => $itemVatAmount,
                ];
            }

            $discountAmount = $validated['discount_amount'] ?? 0;
            $totalAmount = $subtotal - $discountAmount + $taxAmount;

            // Validate payment total
            $paymentTotal = collect($validated['payments'])->sum('amount');
            if (abs($paymentTotal - $totalAmount) > 0.01) {
                throw new \Exception("Payment total (₦{$paymentTotal}) does not match sale total (₦{$totalAmount})");
            }

            // Generate sale number
            $saleNumber = $this->generateSaleNumber();

            // Create sale
            $sale = Sale::create([
                'sale_number' => $saleNumber,
                'branch_id' => $branchId,
                'user_id' => $userId,
                'sale_date' => $validated['sale_date'],
                'subtotal' => $subtotal,
                'tax_amount' => $taxAmount,
                'discount_amount' => $discountAmount,
                'discount_authorized_by' => $discountAuthorizedBy,
                'total_amount' => $totalAmount,
                'customer_name' => $validated['customer_name'] ?? null,
                'customer_phone' => $validated['customer_phone'] ?? null,
                'prescription_number' => $validated['prescription_number'] ?? null,
                'approved_by_pharmacist' => $requiresPharmacistApproval ? $userId : null,
                'status' => Sale::STATUS_COMPLETED,
            ]);

            // Create sale items and update stock
            foreach ($validated['items'] as $item) {
                $stockItem = StockItem::with('drug')->findOrFail($item['stock_item_id']);
                $vatInfo = $itemsWithVat[$item['stock_item_id']] ?? ['vat_rate' => 0, 'vat_amount' => 0];

                // Create sale item with VAT info
                SaleItem::create([
                    'sale_id' => $sale->id,
                    'stock_item_id' => $stockItem->id,
                    'drug_id' => $stockItem->drug_id,
                    'batch_number' => $stockItem->batch_number,
                    'quantity' => $item['quantity'],
                    'unit_price' => $stockItem->selling_price,
                    'subtotal' => $stockItem->selling_price * $item['quantity'],
                    'vat_rate' => $vatInfo['vat_rate'],
                    'vat_amount' => $vatInfo['vat_amount'],
                ]);

                // Update stock quantity
                $stockItem->decrement('quantity_available', $item['quantity']);

                // Create stock movement
                StockMovement::create([
                    'stock_item_id' => $stockItem->id,
                    'user_id' => $userId,
                    'movement_type' => 'sale',
                    'quantity' => -$item['quantity'],
                    'movement_date' => $validated['sale_date'],
                    'reference_type' => Sale::class,
                    'reference_id' => $sale->id,
                    'reason' => "Sale: {$saleNumber}",
                ]);
            }

            // Create payments
            foreach ($validated['payments'] as $payment) {
                Payment::create([
                    'sale_id' => $sale->id,
                    'payment_method' => $payment['payment_method'],
                    'amount' => $payment['amount'],
                    'reference_number' => $payment['reference_number'] ?? null,
                    'payment_date' => $validated['sale_date'],
                ]);
            }

            DB::commit();

            return redirect()->route('sales.show', $sale->id)
                ->with('success', 'Sale completed successfully.');
        } catch (\Exception $e) {
            DB::rollBack();
            return back()->withErrors(['error' => $e->getMessage()])->withInput();
        }
    }

    /**
     * Display the specified sale (receipt view).
     */
    public function show(Sale $sale): Response
    {
        $sale->load([
            'branch',
            'user',
            'pharmacist',
            'items.stockItem.drug',
            'payments',
        ]);

        // Get receipt configuration
        $receiptConfig = SystemConfig::getReceiptConfig();

        return Inertia::render('Sales/Show', [
            'sale' => $sale,
            'receiptConfig' => $receiptConfig,
        ]);
    }

    /**
     * Process a return/refund for a sale.
     */
    public function processReturn(Request $request, Sale $sale)
    {
        $validated = $request->validate([
            'return_date' => 'required|date',
            'return_reason' => 'required|string|max:500',
            'items' => 'required|array|min:1',
            'items.*.sale_item_id' => 'required|exists:sale_items,id',
            'items.*.quantity' => 'required|integer|min:1',
        ]);

        DB::beginTransaction();

        try {
            $userId = $request->user()->id;
            $totalReturnAmount = 0;

            // Validate and process each return item
            foreach ($validated['items'] as $returnItem) {
                $saleItem = SaleItem::with('stockItem')->findOrFail($returnItem['sale_item_id']);

                // Verify the sale item belongs to this sale
                if ($saleItem->sale_id !== $sale->id) {
                    throw new \Exception('Invalid sale item for this sale.');
                }

                // Verify return quantity
                if ($returnItem['quantity'] > $saleItem->quantity) {
                    throw new \Exception("Cannot return more than purchased quantity for item.");
                }

                // Calculate return amount
                $returnAmount = $saleItem->unit_price * $returnItem['quantity'];
                $totalReturnAmount += $returnAmount;

                // Return stock to inventory
                $saleItem->stockItem->increment('quantity_available', $returnItem['quantity']);

                // Create stock movement for return
                StockMovement::create([
                    'stock_item_id' => $saleItem->stock_item_id,
                    'user_id' => $userId,
                    'movement_type' => 'return',
                    'quantity' => $returnItem['quantity'],
                    'movement_date' => $validated['return_date'],
                    'reference_type' => Sale::class,
                    'reference_id' => $sale->id,
                    'reason' => "Return: {$validated['return_reason']}",
                ]);

                // Update sale item quantity (or mark as returned)
                $saleItem->decrement('quantity', $returnItem['quantity']);
            }

            // Update sale status
            $allItemsReturned = $sale->items()->sum('quantity') == 0;
            $sale->update([
                'status' => $allItemsReturned ? Sale::STATUS_RETURNED : Sale::STATUS_PARTIALLY_RETURNED,
            ]);

            DB::commit();

            return redirect()->route('sales.show', $sale->id)
                ->with('success', "Return processed successfully. Refund amount: ₦" . number_format($totalReturnAmount, 2));
        } catch (\Exception $e) {
            DB::rollBack();
            return back()->withErrors(['error' => $e->getMessage()]);
        }
    }

    /**
     * Generate a unique sale number.
     */
    private function generateSaleNumber(): string
    {
        $date = now();
        $prefix = 'SAL-' . $date->format('Ym');

        $lastSale = Sale::where('sale_number', 'like', "{$prefix}%")
            ->orderBy('sale_number', 'desc')
            ->first();

        if ($lastSale) {
            $lastNumber = (int) substr($lastSale->sale_number, -6);
            $newNumber = $lastNumber + 1;
        } else {
            $newNumber = 1;
        }

        return $prefix . str_pad($newNumber, 6, '0', STR_PAD_LEFT);
    }

    /**
     * Lookup a sale by receipt number for returns.
     */
    public function lookupForReturn(Request $request)
    {
        $request->validate([
            'receipt_number' => 'required|string|max:50',
        ]);

        $branchId = $request->user()->branch_id;
        $returnWindowDays = config('pharmacy.return_window_days', 30);

        $sale = Sale::with([
            'items.stockItem.drug',
            'items.drug',
            'payments',
            'user:id,name',
        ])
        ->where('branch_id', $branchId)
        ->where('sale_number', $request->receipt_number)
        ->first();

        if (!$sale) {
            return response()->json([
                'success' => false,
                'message' => 'Sale not found. Please check the receipt number.',
            ], 404);
        }

        // Check if sale is already fully returned
        if ($sale->status === Sale::STATUS_RETURNED) {
            return response()->json([
                'success' => false,
                'message' => 'This sale has already been fully returned.',
            ]);
        }

        // Check return window
        if (!$sale->isWithinReturnWindow($returnWindowDays)) {
            return response()->json([
                'success' => false,
                'message' => "Returns are only allowed within {$returnWindowDays} days of purchase.",
            ]);
        }

        // Transform sale data for return interface
        $saleData = [
            'id' => $sale->id,
            'sale_number' => $sale->sale_number,
            'sale_date' => $sale->sale_date->format('Y-m-d H:i'),
            'sale_date_formatted' => $sale->sale_date->format('M d, Y g:i A'),
            'days_since_sale' => $sale->sale_date->diffInDays(now()),
            'customer_name' => $sale->customer_name ?? 'Walk-in Customer',
            'customer_phone' => $sale->customer_phone,
            'subtotal' => floatval($sale->subtotal),
            'discount_amount' => floatval($sale->discount_amount),
            'total_amount' => floatval($sale->total_amount),
            'status' => $sale->status,
            'cashier' => $sale->user->name,
            'can_be_returned' => $sale->canBeReturned(),
            'returnable_amount' => $sale->returnable_amount,
            'items' => $sale->items->map(function ($item) {
                $drug = $item->drug ?? $item->stockItem?->drug;
                return [
                    'id' => $item->id,
                    'stock_item_id' => $item->stock_item_id,
                    'drug_name' => $drug?->name ?? 'Unknown Product',
                    'generic_name' => $drug?->generic_name,
                    'strength' => $drug?->strength,
                    'batch_number' => $item->batch_number,
                    'quantity_purchased' => $item->quantity,
                    'quantity_returned' => $item->quantity_returned ?? 0,
                    'quantity_returnable' => $item->returnable_quantity,
                    'unit_price' => floatval($item->unit_price),
                    'subtotal' => floatval($item->subtotal),
                    'can_return' => $item->canBeReturned(),
                ];
            }),
            'payments' => $sale->payments->map(function ($payment) {
                return [
                    'id' => $payment->id,
                    'method' => $payment->payment_method,
                    'method_label' => ucfirst(str_replace('_', ' ', $payment->payment_method)),
                    'amount' => floatval($payment->amount),
                ];
            }),
        ];

        return response()->json([
            'success' => true,
            'sale' => $saleData,
        ]);
    }

    /**
     * Validate admin credentials for discount authorization.
     * Supports both password and authorization code authentication.
     */
    public function validateDiscountAuth(Request $request)
    {
        // Determine authentication method
        $authMethod = $request->input('auth_method', 'password');

        if ($authMethod === 'code') {
            // Authorization code method
            $request->validate([
                'authorization_code' => 'required|string|size:6',
            ]);

            // Find user with this authorization code who can authorize
            $admin = User::where('authorization_code', $request->authorization_code)
                ->where('can_authorize', true)
                ->where('is_active', true)
                ->first();

            if (!$admin) {
                return response()->json([
                    'success' => false,
                    'message' => 'Invalid authorization code.',
                ], 401);
            }
        } else {
            // Password method (default)
            $request->validate([
                'email' => 'required|email',
                'password' => 'required|string',
            ]);

            $admin = User::where('email', $request->email)->first();

            if (!$admin || !Hash::check($request->password, $admin->password)) {
                return response()->json([
                    'success' => false,
                    'message' => 'Invalid admin credentials.',
                ], 401);
            }
        }

        // Load role with permissions
        $admin->load('role.permissions');

        // Check if user has admin role, sales.apply_discount permission, or can_authorize flag
        $hasPermission = $admin->role && (
            in_array(strtolower($admin->role->name), ['super admin', 'admin', 'manager', 'pharmacist']) ||
            $admin->role->permissions->contains('name', 'sales.apply_discount') ||
            $admin->can_authorize
        );

        if (!$hasPermission) {
            return response()->json([
                'success' => false,
                'message' => 'User does not have authorization to approve discounts.',
            ], 403);
        }

        return response()->json([
            'success' => true,
            'admin' => [
                'id' => $admin->id,
                'name' => $admin->name,
                'role' => $admin->role->name,
            ],
        ]);
    }

    /**
     * Validate admin credentials for return authorization.
     * Supports both password and authorization code authentication.
     */
    public function validateAdminAuth(Request $request)
    {
        // Determine authentication method
        $authMethod = $request->input('auth_method', 'password');

        if ($authMethod === 'code') {
            // Authorization code method
            $request->validate([
                'authorization_code' => 'required|string|size:6',
            ]);

            // Find user with this authorization code who can authorize
            $admin = User::where('authorization_code', $request->authorization_code)
                ->where('can_authorize', true)
                ->where('is_active', true)
                ->first();

            if (!$admin) {
                return response()->json([
                    'success' => false,
                    'message' => 'Invalid authorization code.',
                ], 401);
            }
        } else {
            // Password method (default)
            $request->validate([
                'email' => 'required|email',
                'password' => 'required|string',
            ]);

            $admin = User::where('email', $request->email)->first();

            if (!$admin || !Hash::check($request->password, $admin->password)) {
                return response()->json([
                    'success' => false,
                    'message' => 'Invalid admin credentials.',
                ], 401);
            }
        }

        // Load role with permissions
        $admin->load('role.permissions');

        // Check if user has admin role or sales.return permission
        $hasPermission = $admin->role && (
            in_array(strtolower($admin->role->name), ['super admin', 'admin', 'manager', 'pharmacist']) ||
            $admin->role->permissions->contains('name', 'sales.return') ||
            $admin->can_authorize
        );

        if (!$hasPermission) {
            return response()->json([
                'success' => false,
                'message' => 'User does not have authorization to approve returns.',
            ], 403);
        }

        return response()->json([
            'success' => true,
            'admin' => [
                'id' => $admin->id,
                'name' => $admin->name,
                'role' => $admin->role->name,
            ],
        ]);
    }

    /**
     * Process a return/refund from the POS interface.
     */
    public function processReturnFromPOS(Request $request)
    {
        $validated = $request->validate([
            'sale_id' => 'required|exists:sales,id',
            'admin_id' => 'required|exists:users,id',
            'reason' => 'required|string|max:500',
            'refund_method' => 'required|in:cash,original_payment,store_credit',
            'items' => 'required|array|min:1',
            'items.*.sale_item_id' => 'required|exists:sale_items,id',
            'items.*.quantity' => 'required|integer|min:1',
        ]);

        $branchId = $request->user()->branch_id;
        $userId = $request->user()->id;

        $sale = Sale::with('items.stockItem')->where('id', $validated['sale_id'])
            ->where('branch_id', $branchId)
            ->first();

        if (!$sale) {
            return response()->json([
                'success' => false,
                'message' => 'Sale not found or does not belong to this branch.',
            ], 404);
        }

        if ($sale->status === Sale::STATUS_RETURNED) {
            return response()->json([
                'success' => false,
                'message' => 'This sale has already been fully returned.',
            ]);
        }

        DB::beginTransaction();

        try {
            $totalRefundAmount = 0;
            $returnItems = [];

            // Validate and calculate return amounts
            foreach ($validated['items'] as $returnItem) {
                $saleItem = $sale->items->find($returnItem['sale_item_id']);

                if (!$saleItem) {
                    throw new \Exception('Invalid item for this sale.');
                }

                // Verify return quantity doesn't exceed returnable quantity
                if ($returnItem['quantity'] > $saleItem->returnable_quantity) {
                    throw new \Exception(
                        "Cannot return {$returnItem['quantity']} units. " .
                        "Only {$saleItem->returnable_quantity} available for return."
                    );
                }

                $refundAmount = floatval($saleItem->unit_price) * $returnItem['quantity'];
                $totalRefundAmount += $refundAmount;

                $returnItems[] = [
                    'sale_item' => $saleItem,
                    'quantity' => $returnItem['quantity'],
                    'refund_amount' => $refundAmount,
                ];
            }

            // Create sale return record
            $saleReturn = SaleReturn::create([
                'return_number' => SaleReturn::generateReturnNumber(),
                'sale_id' => $sale->id,
                'branch_id' => $branchId,
                'processed_by' => $userId,
                'authorized_by' => $validated['admin_id'],
                'return_date' => now(),
                'refund_amount' => $totalRefundAmount,
                'refund_method' => $validated['refund_method'],
                'reason' => $validated['reason'],
                'status' => SaleReturn::STATUS_COMPLETED,
            ]);

            // Process each return item
            foreach ($returnItems as $item) {
                $saleItem = $item['sale_item'];

                // Create return item record
                SaleReturnItem::create([
                    'sale_return_id' => $saleReturn->id,
                    'sale_item_id' => $saleItem->id,
                    'stock_item_id' => $saleItem->stock_item_id,
                    'quantity' => $item['quantity'],
                    'unit_price' => $saleItem->unit_price,
                    'refund_amount' => $item['refund_amount'],
                ]);

                // Update sale item quantity_returned
                $saleItem->increment('quantity_returned', $item['quantity']);

                // Return stock to inventory
                $saleItem->stockItem->increment('quantity_available', $item['quantity']);

                // Create stock movement for audit trail
                StockMovement::create([
                    'stock_item_id' => $saleItem->stock_item_id,
                    'user_id' => $userId,
                    'movement_type' => StockMovement::TYPE_RETURN,
                    'quantity' => $item['quantity'],
                    'unit_cost' => $saleItem->unit_price,
                    'movement_date' => now(),
                    'reference_type' => SaleReturn::class,
                    'reference_id' => $saleReturn->id,
                    'reason' => "Return: {$validated['reason']} (Authorized by admin #{$validated['admin_id']})",
                ]);
            }

            // Update sale status
            $sale->refresh();
            $allItemsReturned = $sale->items->every(fn($item) => $item->isFullyReturned());

            $sale->update([
                'status' => $allItemsReturned
                    ? Sale::STATUS_RETURNED
                    : Sale::STATUS_PARTIALLY_RETURNED,
            ]);

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Return processed successfully.',
                'return' => [
                    'return_number' => $saleReturn->return_number,
                    'refund_amount' => $totalRefundAmount,
                    'refund_method' => $validated['refund_method'],
                    'items_count' => count($returnItems),
                    'sale_status' => $sale->fresh()->status,
                ],
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => $e->getMessage(),
            ], 422);
        }
    }
}
