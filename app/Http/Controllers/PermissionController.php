<?php

namespace App\Http\Controllers;

use App\Models\Permission;
use Illuminate\Http\Request;

class PermissionController extends Controller
{
    /**
     * Get all permissions grouped by module.
     * Used for role assignment interfaces.
     */
    public function index()
    {
        $permissions = Permission::orderBy('module')
            ->orderBy('name')
            ->get()
            ->groupBy('module');

        return response()->json([
            'permissions' => $permissions,
        ]);
    }

    /**
     * Get permissions for a specific module.
     */
    public function byModule(string $module)
    {
        $permissions = Permission::where('module', $module)
            ->orderBy('name')
            ->get();

        return response()->json([
            'permissions' => $permissions,
        ]);
    }
}

