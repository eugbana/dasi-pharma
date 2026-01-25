<?php

namespace App\Http\Middleware;

use App\Models\Branch;
use Illuminate\Http\Request;
use Inertia\Middleware;

class HandleInertiaRequests extends Middleware
{
    /**
     * The root template that's loaded on the first page visit.
     *
     * @see https://inertiajs.com/server-side-setup#root-template
     *
     * @var string
     */
    protected $rootView = 'app';

    /**
     * Determines the current asset version.
     *
     * @see https://inertiajs.com/asset-versioning
     */
    public function version(Request $request): ?string
    {
        return parent::version($request);
    }

    /**
     * Define the props that are shared by default.
     *
     * @see https://inertiajs.com/shared-data
     *
     * @return array<string, mixed>
     */
    public function share(Request $request): array
    {
        $user = $request->user();
        $isSuperAdmin = $user?->isSuperAdmin() ?? false;

        return [
            ...parent::share($request),
            'auth' => [
                'user' => $user ? [
                    'id' => $user->id,
                    'name' => $user->name,
                    'email' => $user->email,
                    'is_super_admin' => $isSuperAdmin,
                    'role' => $user->role ? [
                        'id' => $user->role->id,
                        'name' => $user->role->name,
                    ] : null,
                    'branch' => $user->branch ? [
                        'id' => $user->branch->id,
                        'name' => $user->branch->name,
                        'code' => $user->branch->code,
                    ] : null,
                    'permissions' => $user->role ?
                        $user->role->permissions->pluck('name')->toArray() : [],
                ] : null,
            ],
            // Share menu items based on user permissions
            'menu' => fn () => $user ? $this->getFilteredMenuItems($user) : [],
            // Share all branches for Super Admin users
            'branches' => fn () => $isSuperAdmin
                ? Branch::active()->orderBy('name')->get(['id', 'name', 'code'])
                : [],
            // Current selected branch for filtering (from query or session)
            'selectedBranchId' => fn () => $isSuperAdmin
                ? ($request->query('branch_id') ?? session('selected_branch_id'))
                : $user?->branch_id,
            'flash' => [
                'success' => fn () => $request->session()->get('success'),
                'error' => fn () => $request->session()->get('error'),
                'warning' => fn () => $request->session()->get('warning'),
                'info' => fn () => $request->session()->get('info'),
            ],
        ];
    }

    /**
     * Get filtered menu items based on user permissions.
     *
     * @param  \App\Models\User  $user
     * @return array
     */
    protected function getFilteredMenuItems($user): array
    {
        $menuItems = [
            'inventory' => [
                'title' => 'Inventory',
                'items' => [
                    [
                        'name' => 'Products',
                        'route' => 'products.index',
                        'permission' => 'drugs.view',
                    ],
                    [
                        'name' => 'Stock Items',
                        'route' => 'stock-items.index',
                        'permission' => 'inventory.view',
                    ],
                    [
                        'name' => 'Stock Movements',
                        'route' => 'stock-movements.index',
                        'permission' => 'inventory.view',
                    ],
                    [
                        'name' => 'Stock Transfers',
                        'route' => 'stock-transfers.index',
                        'permission' => 'inventory.view',
                    ],
                ],
            ],
            'sales' => [
                'title' => 'Sales',
                'items' => [
                    [
                        'name' => 'Point of Sale',
                        'route' => 'sales.create',
                        'permission' => 'sales.create',
                    ],
                    [
                        'name' => 'Sales History',
                        'route' => 'sales.index',
                        'permission' => 'sales.view',
                    ],
                ],
            ],
            'procurement' => [
                'title' => 'Procurement',
                'items' => [
                    [
                        'name' => 'Suppliers',
                        'route' => 'suppliers.index',
                        'permission' => 'procurement.manage_suppliers',
                    ],
                    [
                        'name' => 'Purchase Orders',
                        'route' => 'purchase-orders.index',
                        'permission' => 'procurement.create_po',
                    ],
                    [
                        'name' => 'Goods Received',
                        'route' => 'goods-received-notes.index',
                        'permission' => 'procurement.receive_goods',
                    ],
                ],
            ],
            'reports' => [
                'title' => 'Reports',
                'items' => [
                    [
                        'name' => 'Sales Report',
                        'route' => 'reports.sales',
                        'permission' => ['reports.view_all', 'sales.view_reports'],
                        'permission_logic' => 'or',
                    ],
                    [
                        'name' => 'Inventory Report',
                        'route' => 'reports.inventory',
                        'permission' => ['reports.view_all', 'inventory.view_reports'],
                        'permission_logic' => 'or',
                    ],
                    [
                        'name' => 'Procurement Report',
                        'route' => 'reports.procurement',
                        'permission' => ['reports.view_all', 'procurement.view_reports'],
                        'permission_logic' => 'or',
                    ],
                ],
            ],
            'administration' => [
                'title' => 'Administration',
                'items' => [
                    [
                        'name' => 'User Management',
                        'route' => 'users.index',
                        'permission' => 'users.manage',
                        'super_admin_only' => true,
                    ],
                    [
                        'name' => 'Roles & Permissions',
                        'route' => 'roles.index',
                        'permission' => 'users.assign_roles',
                        'super_admin_only' => true,
                    ],
                    [
                        'name' => 'Branches',
                        'route' => 'admin.branches.index',
                        'permission' => 'branches.manage',
                        'super_admin_only' => true,
                    ],
                    [
                        'name' => 'System Config',
                        'route' => 'admin.system-config.index',
                        'permission' => 'settings.manage',
                        'super_admin_only' => true,
                    ],
                ],
            ],
        ];

        // Filter menu items based on permissions
        $filteredMenu = [];
        foreach ($menuItems as $section => $data) {
            $filteredItems = array_filter($data['items'], function ($item) use ($user) {
                return $this->userCanAccessMenuItem($user, $item);
            });

            // Only include section if it has visible items
            if (!empty($filteredItems)) {
                $filteredMenu[$section] = [
                    'title' => $data['title'],
                    'items' => array_values($filteredItems),
                ];
            }
        }

        return $filteredMenu;
    }

    /**
     * Check if user can access a specific menu item.
     *
     * @param  \App\Models\User  $user
     * @param  array  $menuItem
     * @return bool
     */
    protected function userCanAccessMenuItem($user, array $menuItem): bool
    {
        // Check if item is super admin only
        if (isset($menuItem['super_admin_only']) && $menuItem['super_admin_only']) {
            return $user->isSuperAdmin();
        }

        // Super Admin can access everything
        if ($user->isSuperAdmin()) {
            return true;
        }

        // Check permissions
        if (!isset($menuItem['permission'])) {
            return true; // No permission required
        }

        $permissions = is_array($menuItem['permission']) ? $menuItem['permission'] : [$menuItem['permission']];
        $logic = $menuItem['permission_logic'] ?? 'and';

        if ($logic === 'or') {
            return $user->hasAnyPermission($permissions);
        }

        return $user->hasAllPermissions($permissions);
    }
}
