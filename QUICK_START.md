# Quick Start Guide - Dasi Pharma Management System

## 🚀 Start the Application

```bash
# Navigate to project directory
cd "/Users/mac/Desktop/dasi pharma"

# Start the Laravel server
php artisan serve
```

**Server will be available at**: http://127.0.0.1:8000

---

## 🔐 Login

### Access the Login Page
Navigate to: **http://127.0.0.1:8000/login**

### Demo Credentials

| Role | Email | Password |
|------|-------|----------|
| **Admin** | admin@dasipharma.ng | password |
| **Pharmacist** | adebayo@dasipharma.ng | password |
| **Cashier** | chioma@dasipharma.ng | password |

---

## 📊 Dashboard Features

After logging in, you'll see:

### 📈 Key Metrics (Top Cards)
- **Today's Sales**: ₦0.00 (0 transactions)
- **Low Stock Items**: Count of items needing reorder
- **Expiring Soon**: Items expiring in 30 days
- **Expired Items**: Items past expiry date

### 📋 Recent Sales
- Last 5 completed sales
- Customer information
- Sale amounts
- Transaction dates

### ⚠️ Expiring Items
- Items expiring in next 30 days
- Batch numbers
- Expiry dates
- Current quantities
- Color-coded urgency:
  - 🔴 Red: ≤7 days
  - 🟡 Yellow: 8-30 days

---

## 🎨 UI Features

### Responsive Design
- ✅ Desktop optimized
- ✅ Tablet friendly
- ✅ Mobile responsive

### Navigation
- **Sidebar Menu** with sections:
  - 📦 Inventory (Stock Items, Movements, Transfers)
  - 💰 Sales (POS, Sales History)
  - 🛒 Procurement (Purchase Orders, GRN, Suppliers)

### User Interface
- Clean, modern design
- Pharmacy-themed colors
- Smooth transitions
- Professional typography

---

## 🛠️ Development Commands

### Build Assets
```bash
# Production build (optimized)
npm run build

# Development build (with hot reload)
npm run dev
```

### Database Commands
```bash
# Run migrations
php artisan migrate

# Seed database
php artisan db:seed

# Fresh start (reset everything)
php artisan migrate:fresh --seed
```

### Clear Caches
```bash
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear
```

---

## 📁 Project Structure

```
dasi pharma/
├── app/
│   ├── Http/Controllers/
│   │   ├── Auth/LoginController.php
│   │   └── DashboardController.php
│   └── Models/
│       ├── User.php
│       ├── StockItem.php
│       ├── Sale.php
│       └── ...
├── resources/
│   ├── js/
│   │   ├── Pages/
│   │   │   ├── Auth/Login.vue
│   │   │   └── Dashboard/Index.vue
│   │   ├── Components/
│   │   │   ├── Button.vue
│   │   │   ├── Input.vue
│   │   │   └── ...
│   │   └── Layouts/
│   │       └── AppLayout.vue
│   └── css/
│       └── app.css
├── routes/
│   └── web.php
└── database/
    ├── migrations/
    └── seeders/
```

---

## ✅ Current Status

### Phase 1: Foundation ✅ COMPLETE
- Database schema
- Eloquent models
- Relationships
- Authentication

### Phase 2: Core UI ✅ COMPLETE
- Inertia.js + Vue 3
- Tailwind CSS v4
- Dashboard layout
- Component library
- Login system

### Phase 3: Inventory Core 🔜 NEXT
- Batch tracking
- FEFO logic
- Stock movements

### Phase 4: Sales & POS 🔜 UPCOMING
- Point of Sale
- Receipt generation
- Returns processing

---

## 🐛 Troubleshooting

### Issue: Can't see "Sign in" button
**Solution**: The button is there! It's rendered by Vue. Check browser console for errors.

### Issue: 419 Page Expired
**Solution**: 
```bash
php artisan cache:clear
php artisan config:clear
```
Then restart server with `php artisan serve`

### Issue: Dashboard shows errors
**Solution**: Check logs
```bash
tail -f storage/logs/laravel.log
```

### Issue: Styles not loading
**Solution**: Rebuild assets
```bash
npm run build
```

---

## 📚 Documentation

- **FRONTEND_SETUP.md** - Complete frontend documentation
- **TROUBLESHOOTING.md** - Detailed troubleshooting guide
- **POST_LOGIN_FIXES.md** - Recent fixes and changes
- **README.md** - Project overview

---

## 🎯 Quick Tips

1. **Always use** `php artisan serve` (not `php -S`)
2. **Rebuild assets** after making changes: `npm run build`
3. **Check logs** when errors occur: `storage/logs/laravel.log`
4. **Clear caches** if things seem broken
5. **Use demo credentials** for testing

---

## 🌟 Features Highlights

### Security
- ✅ CSRF protection
- ✅ Password hashing
- ✅ Session management
- ✅ Role-based access control

### User Experience
- ✅ Responsive design
- ✅ Form validation
- ✅ Error handling
- ✅ Loading states
- ✅ Success messages

### Performance
- ✅ Optimized assets
- ✅ Lazy loading
- ✅ Efficient queries
- ✅ Caching ready

---

## 📞 Need Help?

1. Check **TROUBLESHOOTING.md** for common issues
2. Review browser console (F12 → Console)
3. Check Laravel logs: `tail -f storage/logs/laravel.log`
4. Verify server is running: `php artisan serve`

---

## 🎉 You're All Set!

The application is ready to use. Log in and explore the dashboard!

**Login URL**: http://127.0.0.1:8000/login

**Demo Email**: admin@dasipharma.ng  
**Demo Password**: password

Happy coding! 🚀

