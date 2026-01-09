# Frontend Setup - Dasi Pharma Management System

## Overview
This document outlines the frontend implementation using **Inertia.js + Vue 3 + Tailwind CSS** for the Dasi Pharma Management System.

## Technology Stack

### Core Technologies
- **Laravel 10** - Backend framework
- **Inertia.js 1.0** - Modern monolith approach (no API needed)
- **Vue 3** - Progressive JavaScript framework with Composition API
- **Tailwind CSS v4** - Utility-first CSS framework
- **Vite** - Fast build tool and dev server

### Additional Packages
- `@inertiajs/vue3` - Inertia.js Vue 3 adapter
- `@tailwindcss/forms` - Better form styling
- `@tailwindcss/postcss` - Tailwind CSS v4 PostCSS plugin
- `ziggy` - Laravel route helper for JavaScript

## Project Structure

```
resources/
├── css/
│   └── app.css                 # Tailwind CSS imports and custom styles
├── js/
│   ├── app.js                  # Main JavaScript entry point
│   ├── Components/             # Reusable Vue components
│   │   ├── Badge.vue          # Status badges
│   │   ├── Button.vue         # Styled buttons with variants
│   │   ├── Input.vue          # Form input with validation
│   │   ├── MetricCard.vue     # Dashboard metric cards
│   │   ├── Modal.vue          # Modal dialogs
│   │   ├── NavLink.vue        # Navigation links
│   │   └── Table.vue          # Data tables
│   ├── Layouts/
│   │   └── AppLayout.vue      # Main application layout with sidebar
│   └── Pages/
│       ├── Auth/
│       │   └── Login.vue      # Login page
│       └── Dashboard/
│           └── Index.vue      # Dashboard home page
└── views/
    └── app.blade.php          # Root Blade template for Inertia
```

## Design System

### Color Palette
The application uses a pharmacy-themed color system:

- **Primary (Medical Green)**: `#22c55e` - Main brand color
- **Secondary (Professional Blue)**: `#3b82f6` - Supporting actions
- **Accent (Pharmacy Orange)**: `#f97316` - Highlights and CTAs
- **Danger (Red)**: `#ef4444` - Errors and critical alerts
- **Warning (Yellow)**: `#eab308` - Expiry warnings

### Typography
- **Font Family**: Inter (from Google Fonts)
- **Font Weights**: 400 (regular), 500 (medium), 600 (semibold), 700 (bold)

## Key Features Implemented

### 1. Authentication System
- **Login Page** (`/login`)
  - Email and password authentication
  - Remember me functionality
  - Form validation with error display
  - Demo credentials display
  - Responsive design

### 2. Dashboard Layout
- **Responsive Sidebar Navigation**
  - Collapsible on mobile
  - Organized by sections (Inventory, Sales, Procurement)
  - Active state indicators
  - User profile display

- **Top Header**
  - Branch information display
  - Logout button
  - Mobile menu toggle

### 3. Dashboard Home Page
- **Key Metrics Cards**
  - Today's sales and transactions
  - Low stock items count
  - Expiring soon items (30 days)
  - Expired items count

- **Recent Sales List**
  - Last 5 sales transactions
  - Customer name, sale number
  - Total amount and items count
  - User who processed the sale

- **Expiring Items List**
  - Items expiring within 30 days
  - Drug name, strength, dosage form
  - Batch number and quantity
  - Color-coded expiry badges

### 4. Reusable Component Library

#### Button Component
```vue
<Button variant="primary" size="md" :loading="false">
  Click Me
</Button>
```
Variants: primary, secondary, danger, success, warning, outline

#### Input Component
```vue
<Input
  v-model="form.email"
  label="Email Address"
  type="email"
  :error="form.errors.email"
  required
/>
```

#### Modal Component
```vue
<Modal :show="showModal" @close="showModal = false" title="Modal Title">
  <p>Modal content</p>
  <template #footer>
    <Button @click="showModal = false">Close</Button>
  </template>
</Modal>
```

#### Badge Component
```vue
<Badge variant="success">Active</Badge>
<Badge variant="danger">Expired</Badge>
```

#### Table Component
```vue
<Table title="Items" :empty="items.length === 0">
  <template #thead>
    <th>Name</th>
    <th>Price</th>
  </template>
  <tr v-for="item in items" :key="item.id">
    <td>{{ item.name }}</td>
    <td>{{ item.price }}</td>
  </tr>
</Table>
```

## Configuration Files

### tailwind.config.js
- Custom color palette
- Inter font family
- Content paths for Vue files
- Tailwind Forms plugin

### vite.config.js
- Laravel Vite plugin
- Vue 3 plugin
- Path alias `@` → `resources/js`

### postcss.config.js
- Tailwind CSS v4 PostCSS plugin
- Autoprefixer

## Backend Integration

### Inertia Middleware
- Shares authentication data globally
- Shares flash messages (success, error, warning, info)
- Provides user, role, branch, and permissions data

### Controllers
- **LoginController**: Handles authentication
- **DashboardController**: Provides dashboard data

### Routes
- `GET /login` - Login page
- `POST /login` - Process login
- `POST /logout` - Logout
- `GET /dashboard` - Dashboard home

## Development Workflow

### Build Assets
```bash
npm run build          # Production build
npm run dev            # Development with hot reload
```

### Start Server
```bash
php artisan serve      # Start Laravel development server
```

### Access Application
- URL: http://localhost:8000
- Login: http://localhost:8000/login

### Demo Credentials
- **Admin**: admin@dasipharma.ng / password
- **Pharmacist**: adebayo@dasipharma.ng / password

## Next Steps

The following modules are ready to be implemented:

1. **Inventory Management**
   - Stock items listing with FEFO display
   - Stock movements tracking
   - Stock transfers between branches

2. **Point of Sale (POS)**
   - Sales interface with FEFO selection
   - Receipt generation
   - Returns processing

3. **Procurement**
   - Purchase orders
   - Goods received notes
   - Supplier management

4. **Reports & Analytics**
   - Sales reports
   - Inventory reports
   - Expiry reports

All the foundation is in place with reusable components, consistent design system, and proper authentication!

