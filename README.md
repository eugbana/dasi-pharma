# Dasi Pharma - Pharmacy Management System

A comprehensive pharmacy management system built with Laravel 11, Inertia.js, and Vue 3. Designed for multi-branch pharmaceutical operations in Nigeria with full regulatory compliance (NAFDAC).

## 🚀 Features

### Core Modules
- **Inventory Management** - Batch tracking with FEFO (First Expiry, First Out) logic
- **Point of Sale (POS)** - Fast checkout with prescription validation
- **Procurement** - Purchase orders and goods receipt with quality control
- **Stock Transfers** - Inter-branch transfers with approval workflow
- **Reporting & Analytics** - Comprehensive business intelligence
- **User Management** - Role-based access control (RBAC)

### Key Capabilities
✅ **Batch & Expiry Tracking** - Full traceability from receipt to sale
✅ **FEFO Compliance** - Automatic batch selection by expiry date
✅ **Controlled Substances** - Pharmacist approval for Schedule II-V drugs
✅ **Multi-Branch Support** - Centralized management across locations
✅ **Audit Trail** - Complete stock movement history
✅ **NAFDAC Compliance** - Regulatory tracking and reporting
✅ **Prescription Management** - Digital prescription tracking
✅ **Quality Control** - GRN approval workflow

## 📋 Requirements

- PHP 8.2+
- Composer
- Node.js 18+ & NPM
- MySQL 8.0+ or SQLite (for development)

## 🛠️ Installation

### 1. Clone the repository
```bash
git clone <repository-url>
cd "dasi pharma"
```

### 2. Install PHP dependencies
```bash
composer install
```

### 3. Install JavaScript dependencies
```bash
npm install
```

### 4. Environment setup
```bash
cp .env.example .env
php artisan key:generate
```

### 5. Configure database
Edit `.env` file:

**For MySQL:**
```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=dasi_pharma
DB_USERNAME=root
DB_PASSWORD=your_password
```

**For SQLite (Development):**
```env
DB_CONNECTION=sqlite
```

### 6. Run migrations and seeders
```bash
# For SQLite, create database file first
touch database/database.sqlite

# Run migrations with sample data
php artisan migrate:fresh --seed
```

### 7. Build frontend assets
```bash
npm run dev
```

### 8. Start development server
```bash
php artisan serve
```

Visit: `http://localhost:8000`

## 🔐 Default Login Credentials

**Super Admin:**
- Email: `admin@dasipharma.ng`
- Password: `password`

**Pharmacist:**
- Email: `adebayo@dasipharma.ng`
- Password: `password`

**Store Manager:**
- Email: `ibrahim@dasipharma.ng`
- Password: `password`

**Sales Staff:**
- Email: `tunde@dasipharma.ng`
- Password: `password`

## 📊 Database Schema

The system uses 21 database tables organized into modules:

### Core Tables
- `users` - User accounts with role and branch assignment
- `roles` - System roles (Super Admin, Pharmacist, Store Manager, Sales Staff)
- `permissions` - Granular permissions by module
- `branches` - Pharmacy branch locations

### Inventory Tables
- `drugs` - Master drug catalog with NAFDAC numbers
- `stock_items` - Batch-level inventory with expiry tracking
- `stock_movements` - Audit trail for all stock changes

### Procurement Tables
- `suppliers` - Vendor management
- `purchase_orders` - PO workflow with approval
- `purchase_order_items` - PO line items
- `goods_received_notes` - GRN with quality control
- `goods_received_items` - GRN line items with batch capture

### Sales Tables
- `sales` - POS transactions with prescription tracking
- `sale_items` - Sale line items with batch traceability
- `payments` - Payment methods (supports split payments)

### Transfer Tables
- `stock_transfers` - Inter-branch transfers
- `stock_transfer_items` - Transfer line items

### System Tables
- `notifications` - System alerts and reminders

See `DATABASE_SCHEMA.md` for complete ERD and detailed documentation.

## 🏗️ Project Structure

```
app/
├── Models/              # Eloquent models with relationships
├── Http/
│   ├── Controllers/     # Request handlers
│   └── Middleware/      # Custom middleware
└── Services/            # Business logic layer

database/
├── migrations/          # Database schema (21 files)
└── seeders/             # Sample data seeders

resources/
├── js/
│   ├── Pages/          # Inertia.js Vue pages
│   └── Components/     # Reusable Vue components
└── css/                # Tailwind CSS styles
```

## 🧪 Testing

```bash
# Run all tests
php artisan test

# Run specific test suite
php artisan test --testsuite=Feature
```

## 📝 Development Roadmap

### ✅ Phase 1: Foundation (COMPLETED)
- [x] Database schema design
- [x] Migration files with constraints
- [x] Eloquent models with relationships
- [x] Database seeders

### 🚧 Phase 2: Core UI (IN PROGRESS)
- [ ] Dashboard layout with Inertia.js
- [ ] Authentication system
- [ ] Reusable component library
- [ ] Responsive design with Tailwind CSS

### 📅 Phase 3: Inventory Core
- [ ] Batch tracking interface
- [ ] FEFO selection logic
- [ ] Stock movement recording
- [ ] Expiry alerts

### 📅 Phase 4: Sales & POS
- [ ] Point of sale interface
- [ ] Receipt generation
- [ ] Returns processing
- [ ] Payment handling

## 📄 License

Proprietary - All rights reserved

## 👥 Support

For support, email support@dasipharma.ng
