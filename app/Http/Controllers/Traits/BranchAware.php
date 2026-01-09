<?php

namespace App\Http\Controllers\Traits;

use Illuminate\Http\Request;
use Illuminate\Database\Eloquent\Builder;

/**
 * BranchAware Trait
 * 
 * Provides branch filtering functionality for controllers.
 * Super Admin users can view all branches or filter by specific branch.
 * Regular users are restricted to their assigned branch.
 */
trait BranchAware
{
    /**
     * Get the effective branch ID for the current request.
     * 
     * @param Request $request
     * @return int|null Returns null if Super Admin should see all branches
     */
    protected function getEffectiveBranchId(Request $request): ?int
    {
        $user = $request->user();
        
        // If user is Super Admin
        if ($user->isSuperAdmin()) {
            // Check if a specific branch is selected via query parameter or session
            $selectedBranch = $request->query('branch_id') ?? session('selected_branch_id');
            
            // Return null to indicate all branches, or the selected branch ID
            return $selectedBranch ? (int) $selectedBranch : null;
        }
        
        // Regular users always use their assigned branch
        return $user->branch_id;
    }

    /**
     * Apply branch filter to a query builder.
     * 
     * @param Builder $query
     * @param Request $request
     * @param string $branchColumn The column name for branch_id (default: 'branch_id')
     * @return Builder
     */
    protected function applyBranchFilter(Builder $query, Request $request, string $branchColumn = 'branch_id'): Builder
    {
        $branchId = $this->getEffectiveBranchId($request);
        
        // If null, Super Admin sees all branches (no filter applied)
        if ($branchId === null) {
            return $query;
        }
        
        return $query->where($branchColumn, $branchId);
    }

    /**
     * Apply branch filter to a query via a relationship.
     * Useful when filtering by branch through a related model.
     * 
     * @param Builder $query
     * @param Request $request
     * @param string $relationship The relationship name (e.g., 'stockItem')
     * @param string $branchColumn The column name for branch_id in the related model
     * @return Builder
     */
    protected function applyBranchFilterViaRelation(
        Builder $query, 
        Request $request, 
        string $relationship, 
        string $branchColumn = 'branch_id'
    ): Builder {
        $branchId = $this->getEffectiveBranchId($request);
        
        // If null, Super Admin sees all branches (no filter applied)
        if ($branchId === null) {
            return $query;
        }
        
        return $query->whereHas($relationship, function ($q) use ($branchColumn, $branchId) {
            $q->where($branchColumn, $branchId);
        });
    }

    /**
     * Check if the current user can access data from a specific branch.
     * 
     * @param Request $request
     * @param int $branchId
     * @return bool
     */
    protected function canAccessBranch(Request $request, int $branchId): bool
    {
        return $request->user()->canAccessBranch($branchId);
    }

    /**
     * Get branch filter information for the frontend.
     * 
     * @param Request $request
     * @return array
     */
    protected function getBranchFilterInfo(Request $request): array
    {
        $user = $request->user();
        
        return [
            'is_super_admin' => $user->isSuperAdmin(),
            'selected_branch_id' => $this->getEffectiveBranchId($request),
            'user_branch_id' => $user->branch_id,
            'can_switch_branches' => $user->isSuperAdmin(),
        ];
    }
}

