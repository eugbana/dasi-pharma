<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

/**
 * User Model
 *
 * Represents system users with role-based access control.
 * Each user is assigned to a specific branch and role.
 */
class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable, SoftDeletes;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'name',
        'email',
        'password',
        'authorization_code',
        'can_authorize',
        'role_id',
        'branch_id',
        'is_active',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'authorization_code',
        'remember_token',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
        'password' => 'hashed',
        'is_active' => 'boolean',
        'can_authorize' => 'boolean',
    ];

    /**
     * Get the role assigned to this user.
     */
    public function role(): BelongsTo
    {
        return $this->belongsTo(Role::class);
    }

    /**
     * Get the branch this user is assigned to.
     */
    public function branch(): BelongsTo
    {
        return $this->belongsTo(Branch::class);
    }

    /**
     * Get all stock movements created by this user.
     */
    public function stockMovements(): HasMany
    {
        return $this->hasMany(StockMovement::class);
    }

    /**
     * Get all sales processed by this user.
     */
    public function sales(): HasMany
    {
        return $this->hasMany(Sale::class);
    }

    /**
     * Get all purchase orders created by this user.
     */
    public function purchaseOrders(): HasMany
    {
        return $this->hasMany(PurchaseOrder::class, 'created_by');
    }

    /**
     * Get all notifications for this user.
     */
    public function notifications(): HasMany
    {
        return $this->hasMany(Notification::class);
    }

    /**
     * Check if user has a specific permission.
     */
    public function hasPermission(string $permissionName): bool
    {
        // Super Admin has all permissions
        if ($this->isSuperAdmin()) {
            return true;
        }

        // Check if role has the permission
        return $this->role?->hasPermission($permissionName) ?? false;
    }

    /**
     * Check if user has ANY of the specified permissions (OR logic).
     *
     * @param  array  $permissions  Array of permission names
     * @return bool
     */
    public function hasAnyPermission(array $permissions): bool
    {
        // Super Admin has all permissions
        if ($this->isSuperAdmin()) {
            return true;
        }

        foreach ($permissions as $permission) {
            if ($this->hasPermission($permission)) {
                return true;
            }
        }

        return false;
    }

    /**
     * Check if user has ALL of the specified permissions (AND logic).
     *
     * @param  array  $permissions  Array of permission names
     * @return bool
     */
    public function hasAllPermissions(array $permissions): bool
    {
        // Super Admin has all permissions
        if ($this->isSuperAdmin()) {
            return true;
        }

        foreach ($permissions as $permission) {
            if (!$this->hasPermission($permission)) {
                return false;
            }
        }

        return true;
    }

    /**
     * Check if user has a specific role.
     */
    public function hasRole(string $roleName): bool
    {
        return $this->role?->name === $roleName;
    }

    /**
     * Check if user is a Super Admin.
     */
    public function isSuperAdmin(): bool
    {
        return $this->role?->name === 'Super Admin';
    }

    /**
     * Check if user is a pharmacist.
     */
    public function isPharmacist(): bool
    {
        return $this->hasRole('Pharmacist') || $this->isSuperAdmin();
    }

    /**
     * Get the effective branch ID for queries.
     * Returns null for Super Admin (indicating all branches) unless a specific branch is selected.
     */
    public function getEffectiveBranchId(?int $selectedBranchId = null): ?int
    {
        // If user is Super Admin and a branch is selected, use that
        if ($this->isSuperAdmin()) {
            return $selectedBranchId; // null means all branches
        }

        // Regular users always use their assigned branch
        return $this->branch_id;
    }

    /**
     * Check if user can access data from a specific branch.
     */
    public function canAccessBranch(int $branchId): bool
    {
        // Super Admin can access all branches
        if ($this->isSuperAdmin()) {
            return true;
        }

        // Regular users can only access their own branch
        return $this->branch_id === $branchId;
    }

    /**
     * Check if user can authorize sensitive operations.
     */
    public function canAuthorize(): bool
    {
        return $this->can_authorize && $this->is_active && !empty($this->authorization_code);
    }

    /**
     * Validate the provided authorization code.
     */
    public function validateAuthorizationCode(string $code): bool
    {
        if (!$this->canAuthorize()) {
            return false;
        }
        return $this->authorization_code === $code;
    }

    /**
     * Set a new authorization code (stores as plain text since it's a short PIN).
     */
    public function setAuthorizationCode(string $code): void
    {
        $this->authorization_code = $code;
        $this->save();
    }

    /**
     * Scope to get only active users.
     */
    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }

    /**
     * Scope to filter users by role.
     */
    public function scopeByRole($query, string $roleName)
    {
        return $query->whereHas('role', function ($q) use ($roleName) {
            $q->where('name', $roleName);
        });
    }

    /**
     * Scope to filter users by branch.
     */
    public function scopeByBranch($query, int $branchId)
    {
        return $query->where('branch_id', $branchId);
    }

    /**
     * Scope to get users who can authorize.
     */
    public function scopeCanAuthorize($query)
    {
        return $query->where('can_authorize', true)
            ->whereNotNull('authorization_code');
    }
}
