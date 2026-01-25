<?php

namespace App\Http\Controllers;

use App\Models\Branch;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;
use Inertia\Response;

class BranchController extends Controller
{
    /**
     * Display a listing of branches.
     */
    public function index(Request $request): Response
    {
        $query = Branch::query()
            ->withCount(['users', 'stockItems', 'sales']);

        // Search filter
        if ($request->filled('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                  ->orWhere('code', 'like', "%{$search}%")
                  ->orWhere('address', 'like', "%{$search}%")
                  ->orWhere('phone', 'like', "%{$search}%");
            });
        }

        // Status filter
        if ($request->filled('status')) {
            $query->where('is_active', $request->status === 'active');
        }

        $branches = $query->orderBy('name')->paginate(15)->withQueryString();

        return Inertia::render('Admin/Branches/Index', [
            'branchesList' => $branches,
            'filters' => $request->only(['search', 'status']),
        ]);
    }

    /**
     * Show the form for creating a new branch.
     */
    public function create(): Response
    {
        $managers = User::whereHas('role', function ($q) {
            $q->whereIn('name', ['Super Admin', 'Store Manager', 'Pharmacist']);
        })->get(['id', 'name', 'email']);

        return Inertia::render('Admin/Branches/Create', [
            'managers' => $managers,
        ]);
    }

    /**
     * Store a newly created branch.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255|unique:branches,name',
            'code' => 'required|string|max:20|unique:branches,code',
            'address' => 'required|string|max:500',
            'phone' => 'nullable|string|max:20',
            'email' => 'nullable|email|max:255',
            'is_active' => 'boolean',
        ]);

        $branch = Branch::create($validated);

        return redirect()->route('admin.branches.show', $branch)
            ->with('success', 'Branch created successfully.');
    }

    /**
     * Display the specified branch.
     */
    public function show(Branch $branch): Response
    {
        $branch->load(['users' => function ($q) {
            $q->with('role:id,name')->select('id', 'name', 'email', 'role_id', 'branch_id');
        }]);

        // Get stock summary
        $stockSummary = DB::table('stock_items')
            ->where('branch_id', $branch->id)
            ->whereNull('deleted_at')
            ->selectRaw('
                COUNT(*) as total_items,
                SUM(quantity_available) as total_quantity,
                SUM(quantity_available * purchase_price) as stock_value,
                COUNT(CASE WHEN quantity_available <= minimum_stock_level THEN 1 END) as low_stock_count,
                COUNT(CASE WHEN expiry_date <= DATE_ADD(CURDATE(), INTERVAL 30 DAY) THEN 1 END) as expiring_soon
            ')
            ->first();

        // Get recent sales
        $recentSales = $branch->sales()
            ->with('user:id,name')
            ->latest('sale_date')
            ->limit(10)
            ->get(['id', 'sale_number', 'sale_date', 'total_amount', 'user_id', 'status']);

        return Inertia::render('Admin/Branches/Show', [
            'branch' => $branch,
            'stockSummary' => $stockSummary,
            'recentSales' => $recentSales,
        ]);
    }

    /**
     * Show the form for editing the specified branch.
     */
    public function edit(Branch $branch): Response
    {
        return Inertia::render('Admin/Branches/Edit', [
            'branch' => $branch,
        ]);
    }

    /**
     * Update the specified branch.
     */
    public function update(Request $request, Branch $branch)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255|unique:branches,name,' . $branch->id,
            'code' => 'required|string|max:20|unique:branches,code,' . $branch->id,
            'address' => 'required|string|max:500',
            'phone' => 'nullable|string|max:20',
            'email' => 'nullable|email|max:255',
            'is_active' => 'boolean',
        ]);

        $branch->update($validated);

        return redirect()->route('admin.branches.show', $branch)
            ->with('success', 'Branch updated successfully.');
    }

    /**
     * Remove the specified branch (soft delete).
     */
    public function destroy(Branch $branch)
    {
        // Check if branch has active users
        if ($branch->users()->count() > 0) {
            return back()->with('error', 'Cannot delete branch with assigned users.');
        }

        $branch->delete();

        return redirect()->route('admin.branches.index')
            ->with('success', 'Branch deleted successfully.');
    }

    /**
     * Set the selected branch in session for filtering.
     */
    public function setSelectedBranch(Request $request)
    {
        $branchId = $request->input('branch_id');

        if ($branchId) {
            // Validate that the branch exists
            $branch = Branch::find($branchId);
            if ($branch) {
                session(['selected_branch_id' => (int) $branchId]);
            }
        } else {
            // Clear the selection (All Branches)
            session()->forget('selected_branch_id');
        }

        return response()->json(['success' => true, 'selected_branch_id' => session('selected_branch_id')]);
    }
}

