# Pharmaceutical Inventory & POS - Database Schema Documentation

## Overview
This document provides comprehensive documentation for the database schema design, including design decisions, business rules, and indexing strategy.

## Design Principles
1. **Normalization**: All tables are in 3NF to eliminate data redundancy
2. **Audit Trail**: Soft deletes and timestamps on all critical tables
3. **Data Integrity**: Foreign key constraints with appropriate cascade rules
4. **Performance**: Strategic indexing on foreign keys and frequently queried columns
5. **Compliance**: Built-in support for regulatory requirements (NAFDAC, controlled substances)

## Core Entities

### 1. Users & Authentication

#### users
**Purpose**: Store user accounts with role-based access control
**Business Rules**:
- Email must be unique across the system
- Users must be assigned to a specific branch (their primary location)
- Soft deletes preserve audit trail when users are deactivated

**Indexes**:
- PRIMARY KEY (id)
- UNIQUE (email)
- INDEX (role_id, branch_id) - for filtering users by role and branch
- INDEX (deleted_at) - for soft delete queries

#### roles
**Purpose**: Define system roles (Super Admin, Pharmacist, Store Manager, Sales Staff)
**Business Rules**:
- Role names must be unique
- Roles are seeded during installation and rarely modified

**Indexes**:
- PRIMARY KEY (id)
- UNIQUE (name)

#### permissions
**Purpose**: Granular permissions for specific actions
**Business Rules**:
- Permissions are grouped by module (inventory, sales, procurement, reports)
- Permission names follow convention: module.action (e.g., 'sales.approve_controlled_substance')

**Indexes**:
- PRIMARY KEY (id)
- UNIQUE (name)
- INDEX (module) - for filtering permissions by module

#### role_permissions
**Purpose**: Many-to-many relationship between roles and permissions
**Business Rules**:
- Composite unique constraint on (role_id, permission_id)

**Indexes**:
- PRIMARY KEY (id)
- UNIQUE (role_id, permission_id)
- INDEX (permission_id) - for reverse lookups

### 2. Branch Management

#### branches
**Purpose**: Multi-branch support for pharmacy chains
**Business Rules**:
- Branch code must be unique (used for internal reference)
- Soft deletes prevent accidental data loss
- is_active flag for temporary closures without deletion

**Indexes**:
- PRIMARY KEY (id)
- UNIQUE (code)
- INDEX (is_active, deleted_at) - for filtering active branches

### 3. Drug Master Data

#### drugs
**Purpose**: Master catalog of pharmaceutical products
**Business Rules**:
- NAFDAC registration number must be unique
- Unique constraint on (brand_name, strength, dosage_form) prevents duplicates
- controlled_substance_class: NULL, 'Schedule II', 'Schedule III', 'Schedule IV', 'Schedule V'
- is_prescription_only enforced at POS layer

**Indexes**:
- PRIMARY KEY (id)
- UNIQUE (nafdac_number)
- UNIQUE (brand_name, strength, dosage_form)
- INDEX (generic_name) - for generic name searches
- INDEX (is_prescription_only, controlled_substance_class) - for regulatory filtering
- FULLTEXT (brand_name, generic_name) - for fast search

### 4. Inventory Management (CRITICAL)

#### stock_items
**Purpose**: Track specific batches of drugs at each branch
**Business Rules**:
- Each batch is a separate stock_item (same drug, different batch = different record)
- Unique constraint on (drug_id, branch_id, batch_number) prevents duplicate batch entries
- quantity_available updated via stock_movements (never directly)
- expiry_date used for FEFO (First Expired, First Out) logic
- Soft deletes preserve historical batch data

**Indexes**:
- PRIMARY KEY (id)
- UNIQUE (drug_id, branch_id, batch_number)
- INDEX (branch_id, expiry_date) - for expiry alerts and FEFO selection
- INDEX (drug_id, quantity_available) - for stock availability checks
- INDEX (expiry_date) - for daily expiry check jobs

**Design Decision**: Separate stock_items per batch enables precise expiry tracking and FEFO compliance.

#### stock_movements
**Purpose**: Comprehensive audit trail of all inventory changes
**Business Rules**:
- movement_type: 'purchase', 'sale', 'transfer_in', 'transfer_out', 'adjustment', 'expiry', 'return'
- reference_type and reference_id create polymorphic relationship to source transaction
- quantity: positive for increases, negative for decreases
- movement_date allows backdating for corrections (with proper authorization)

**Indexes**:
- PRIMARY KEY (id)
- INDEX (stock_item_id, movement_date) - for batch history
- INDEX (user_id, movement_date) - for user activity reports
- INDEX (reference_type, reference_id) - for tracing source transactions
- INDEX (movement_type, movement_date) - for movement type reports

**Design Decision**: Polymorphic relationship allows linking to sales, purchases, transfers, etc.

### 5. Procurement

#### suppliers
**Purpose**: Vendor master data
**Business Rules**:
- payment_terms: 'Cash', 'Net 30', 'Net 60', etc.
- delivery_days: expected delivery time for planning
- is_active flag for vendor status management

**Indexes**:
- PRIMARY KEY (id)
- INDEX (is_active) - for filtering active suppliers
- INDEX (name) - for supplier search

#### purchase_orders
**Purpose**: Track purchase orders from suppliers
**Business Rules**:
- order_number auto-generated with format: PO-YYYY-MM-NNNN
- status: 'draft', 'pending_approval', 'approved', 'partially_received', 'completed', 'cancelled'
- approved_by must be user with 'procurement.approve_po' permission
- total_amount calculated from purchase_order_items

**Indexes**:
- PRIMARY KEY (id)
- UNIQUE (order_number)
- INDEX (supplier_id, status, order_date) - for supplier order history
- INDEX (branch_id, status) - for branch procurement dashboard
- INDEX (status, expected_delivery_date) - for delivery tracking

#### purchase_order_items
**Purpose**: Line items for purchase orders
**Business Rules**:
- subtotal = quantity_ordered * unit_price (calculated)
- Cascade delete when parent PO is deleted

**Indexes**:
- PRIMARY KEY (id)
- INDEX (purchase_order_id) - for PO line items
- INDEX (drug_id) - for drug purchase history

#### goods_received_notes (GRN)
**Purpose**: Record actual receipt of goods from suppliers
**Business Rules**:
- grn_number auto-generated with format: GRN-YYYY-MM-NNNN
- status: 'pending_quality_check', 'approved', 'rejected'
- Multiple GRNs can reference same PO (partial deliveries)
- received_by must be authorized user

**Indexes**:
- PRIMARY KEY (id)
- UNIQUE (grn_number)
- INDEX (purchase_order_id, received_date) - for PO fulfillment tracking
- INDEX (branch_id, status) - for branch receiving dashboard

#### goods_received_items
**Purpose**: Line items for GRN with batch details
**Business Rules**:
- Batch number and expiry date captured at receipt
- quality_check_passed must be true before stock is added
- Creates corresponding stock_item and stock_movement when approved

**Indexes**:
- PRIMARY KEY (id)
- INDEX (grn_id) - for GRN line items
- INDEX (drug_id, batch_number) - for batch tracking
- INDEX (expiry_date) - for expiry monitoring

**Design Decision**: Separate GRN from PO allows partial deliveries and quality control workflow.

### 6. Sales & POS

#### sales
**Purpose**: Record point-of-sale transactions
**Business Rules**:
- sale_number auto-generated with format: SAL-YYYY-MM-NNNNNN
- status: 'completed', 'returned', 'partially_returned'
- prescription_number required if any item is prescription-only
- approved_by_pharmacist required for controlled substances
- total_amount = subtotal + tax_amount - discount_amount

**Indexes**:
- PRIMARY KEY (id)
- UNIQUE (sale_number)
- INDEX (branch_id, sale_date) - for daily sales reports
- INDEX (user_id, sale_date) - for staff performance reports
- INDEX (customer_phone) - for customer purchase history
- INDEX (prescription_number) - for prescription tracking

#### sale_items
**Purpose**: Line items for sales with batch traceability
**Business Rules**:
- stock_item_id links to specific batch (FEFO compliance)
- batch_number denormalized for reporting (even if stock_item deleted)
- subtotal = quantity * unit_price
- Triggers stock_movement creation on insert

**Indexes**:
- PRIMARY KEY (id)
- INDEX (sale_id) - for sale line items
- INDEX (stock_item_id) - for batch sales tracking
- INDEX (drug_id) - for drug sales reports

#### payments
**Purpose**: Track payment methods for sales (supports split payments)
**Business Rules**:
- payment_method: 'cash', 'card', 'transfer', 'mobile_money'
- Multiple payment records allowed per sale (split payments)
- SUM(amount) for sale_id must equal sale.total_amount

**Indexes**:
- PRIMARY KEY (id)
- INDEX (sale_id) - for sale payments
- INDEX (payment_method, payment_date) - for payment method reports

### 7. Stock Transfers

#### stock_transfers
**Purpose**: Inter-branch stock transfers
**Business Rules**:
- transfer_number auto-generated with format: TRF-YYYY-MM-NNNN
- status: 'pending', 'approved', 'in_transit', 'received', 'cancelled'
- approved_by must have 'inventory.approve_transfer' permission
- Creates stock_movements at both branches when received

**Indexes**:
- PRIMARY KEY (id)
- UNIQUE (transfer_number)
- INDEX (from_branch_id, status) - for outgoing transfers
- INDEX (to_branch_id, status) - for incoming transfers
- INDEX (status, transfer_date) - for transfer tracking

#### stock_transfer_items
**Purpose**: Line items for stock transfers
**Business Rules**:
- stock_item_id references source branch stock
- batch_number preserved for traceability
- Creates new stock_item at destination branch

**Indexes**:
- PRIMARY KEY (id)
- INDEX (stock_transfer_id) - for transfer line items
- INDEX (stock_item_id) - for batch transfer history

### 8. Notifications

#### notifications
**Purpose**: System notifications for alerts and reminders
**Business Rules**:
- type: 'expiry_alert', 'low_stock', 'reorder_point', 'approval_required', 'system'
- data: JSON field for notification-specific data
- Auto-generated by scheduled jobs and business events

**Indexes**:
- PRIMARY KEY (id)
- INDEX (user_id, is_read, created_at) - for user notification feed
- INDEX (type, created_at) - for notification type filtering

## Critical Business Rules Enforced at Database Level

### 1. Expiry Prevention
```sql
-- Check constraint on stock_items
CHECK (expiry_date > manufacturing_date)

-- Trigger to prevent sales of expired items
CREATE TRIGGER prevent_expired_sales BEFORE INSERT ON sale_items
```

### 2. Stock Quantity Integrity
```sql
-- Check constraint on stock_items
CHECK (quantity_available >= 0)

-- Trigger to update quantity_available on stock_movements
CREATE TRIGGER update_stock_quantity AFTER INSERT ON stock_movements
```

### 3. Unique Batch Tracking
```sql
-- Composite unique constraint
UNIQUE KEY unique_batch_per_branch (drug_id, branch_id, batch_number)
```

### 4. Controlled Substance Approval
```sql
-- Check constraint on sales
CHECK (
  (controlled_substance_class IS NULL) OR
  (approved_by_pharmacist IS NOT NULL)
)
```

## Indexing Strategy Summary

**High-Priority Indexes** (Query Performance):
1. Foreign keys (all relationships)
2. Unique constraints (business rules)
3. Date fields used in range queries (expiry_date, sale_date, movement_date)
4. Status fields used in filtering
5. Composite indexes for common query patterns

**Full-Text Indexes**:
1. drugs (brand_name, generic_name) - for product search

**Soft Delete Indexes**:
1. All tables with soft deletes include deleted_at in composite indexes

## Migration Sequence

1. **Foundation**: roles, permissions, role_permissions
2. **Organization**: branches
3. **Users**: users (depends on roles, branches)
4. **Master Data**: drugs, suppliers
5. **Inventory**: stock_items, stock_movements
6. **Procurement**: purchase_orders, purchase_order_items, goods_received_notes, goods_received_items
7. **Sales**: sales, sale_items, payments
8. **Transfers**: stock_transfers, stock_transfer_items
9. **System**: notifications

## Next Steps
1. Create Laravel migration files following this schema
2. Implement Eloquent models with relationships
3. Add database seeders for roles, permissions, and sample data
4. Create service layer for business logic enforcement



