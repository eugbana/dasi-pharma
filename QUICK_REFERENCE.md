# Quick Reference Guide - Dasi Pharma

## 🔑 Key Concepts

### FEFO (First Expiry, First Out)
The system automatically selects batches with the earliest expiry date when processing sales. This is implemented in the `StockItem` model:

```php
// Get batches in FEFO order
$batches = StockItem::where('drug_id', $drugId)
    ->where('branch_id', $branchId)
    ->fefo()
    ->get();
```

### Batch Tracking
Every stock item is tracked by batch number, ensuring full traceability:
- **Unique constraint**: `(drug_id, branch_id, batch_number)`
- **Captured at**: Goods receipt (GRN)
- **Tracked through**: Stock movements, sales, transfers
- **Denormalized in**: Sale items for historical reporting

### Stock Movements
All inventory changes are recorded in `stock_movements` table:
- **Types**: `in`, `out`, `adjustment`, `transfer_in`, `transfer_out`
- **Polymorphic**: Links to source transaction (sale, GRN, transfer)
- **Audit trail**: User, timestamp, quantity, reason

## 📊 Common Queries

### Check Stock Availability
```php
// Get available quantity for a drug at a branch
$totalStock = StockItem::where('drug_id', $drugId)
    ->where('branch_id', $branchId)
    ->sum('quantity_available');

// Get batches with stock
$batches = StockItem::where('drug_id', $drugId)
    ->where('branch_id', $branchId)
    ->inStock()
    ->get();
```

### Find Expiring Items
```php
// Get expired items
$expired = StockItem::expired()->get();

// Get items expiring within 30 days
$expiringSoon = StockItem::expiringSoon(30)->get();

// Get items expiring at a specific branch
$branchExpiring = StockItem::where('branch_id', $branchId)
    ->expiringSoon(60)
    ->get();
```

### Sales by Date Range
```php
// Get sales for a period
$sales = Sale::dateRange($startDate, $endDate)
    ->where('branch_id', $branchId)
    ->completed()
    ->get();

// Calculate total revenue
$revenue = Sale::dateRange($startDate, $endDate)
    ->completed()
    ->sum('total_amount');
```

### User Permissions
```php
// Check if user has permission
if ($user->hasPermission('sales.create')) {
    // Process sale
}

// Check if user is pharmacist
if ($user->isPharmacist()) {
    // Approve controlled substance
}

// Get users by role
$pharmacists = User::byRole('Pharmacist')->get();
```

## 🔐 Role Permissions Matrix

| Permission | Super Admin | Pharmacist | Store Manager | Sales Staff |
|-----------|-------------|------------|---------------|-------------|
| **Inventory** |
| View inventory | ✅ | ✅ | ✅ | ✅ |
| Manage inventory | ✅ | ✅ | ✅ | ❌ |
| Stock adjustments | ✅ | ❌ | ✅ | ❌ |
| Approve transfers | ✅ | ❌ | ✅ | ❌ |
| **Sales** |
| Create sales | ✅ | ✅ | ✅ | ✅ |
| Approve controlled substances | ✅ | ✅ | ❌ | ❌ |
| Process returns | ✅ | ✅ | ✅ | ❌ |
| Apply discounts | ✅ | ✅ | ✅ | ❌ |
| **Procurement** |
| Create PO | ✅ | ✅ | ✅ | ❌ |
| Approve PO | ✅ | ❌ | ✅ | ❌ |
| Receive goods | ✅ | ✅ | ✅ | ❌ |
| Quality check | ✅ | ✅ | ✅ | ❌ |
| **Users** |
| View users | ✅ | ❌ | ✅ | ❌ |
| Manage users | ✅ | ❌ | ❌ | ❌ |
| Assign roles | ✅ | ❌ | ❌ | ❌ |

## 🔄 Workflow Examples

### Purchase Order to Stock
1. **Create PO** → `purchase_orders` (status: `pending`)
2. **Approve PO** → Update status to `approved`
3. **Receive Goods** → Create `goods_received_note` (status: `pending_quality_check`)
4. **Quality Check** → Update GRN items with `quality_check_passed`
5. **Approve GRN** → Create `stock_items` and `stock_movements` (type: `in`)

### Sale Transaction
1. **Select Items** → Query `stock_items` using FEFO
2. **Validate Prescription** → Check if drug requires prescription
3. **Pharmacist Approval** → Required for controlled substances
4. **Process Payment** → Create `payments` record(s)
5. **Complete Sale** → Create `sale`, `sale_items`, and `stock_movements` (type: `out`)

### Stock Transfer
1. **Request Transfer** → Create `stock_transfer` (status: `pending`)
2. **Approve Transfer** → Update status to `approved`
3. **Mark In Transit** → Update status to `in_transit`
4. **Receive at Destination** → Update status to `received`
5. **Update Stock** → Create `stock_movements` at both branches

## 📈 Key Metrics

### Inventory Metrics
- **Stock Value**: `SUM(quantity_available * unit_price)`
- **Expiry Risk**: Count of items expiring within 90 days
- **Stock Turnover**: Sales / Average Inventory
- **Dead Stock**: Items with no movement in 180 days

### Sales Metrics
- **Daily Revenue**: `SUM(total_amount)` by date
- **Average Transaction Value**: `AVG(total_amount)`
- **Items per Transaction**: `AVG(item_count)`
- **Payment Method Mix**: Group by `payment_method`

### Operational Metrics
- **Pending Approvals**: Count of pending POs, transfers, GRNs
- **Low Stock Alerts**: Items below reorder point
- **Expiry Alerts**: Items expiring within threshold
- **User Activity**: Stock movements by user

## 🚨 Important Business Rules

1. **Batch Uniqueness**: Each batch number must be unique per drug per branch
2. **FEFO Enforcement**: Always select earliest expiry batch first
3. **Controlled Substances**: Require pharmacist approval for Schedule II-V drugs
4. **Prescription Validation**: Prescription-only drugs must have prescription number
5. **Quality Control**: All received goods must pass quality check before adding to stock
6. **Stock Transfers**: Require approval before processing
7. **Negative Stock Prevention**: Quantity cannot go below zero (enforced by check constraint)
8. **Expiry Validation**: Expiry date must be after manufacturing date

## 🛠️ Useful Artisan Commands

```bash
# Fresh migration with sample data
php artisan migrate:fresh --seed

# Run specific seeder
php artisan db:seed --class=DrugSeeder

# Clear all caches
php artisan optimize:clear

# Generate IDE helper (for better autocomplete)
php artisan ide-helper:models

# Check database connection
php artisan db:show
```

## 📞 Quick Contacts

- **Technical Support**: tech@dasipharma.ng
- **Business Support**: support@dasipharma.ng
- **Emergency**: +234 800 PHARMA (742762)

