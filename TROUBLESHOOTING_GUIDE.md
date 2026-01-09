# Dasi Pharma - Troubleshooting Guide

## ✅ Issues Fixed

### 1. Sidebar Not Visible on Desktop
**Problem**: The sidebar was hidden by default on all screen sizes.

**Solution**: Added `lg:translate-x-0` class to the sidebar to ensure it's always visible on desktop screens (≥1024px).

**File Changed**: `resources/js/Layouts/AppLayout.vue`

```vue
<!-- Before -->
<div class="... transform transition-transform duration-300 ease-in-out"
     :class="{ '-translate-x-full': !sidebarOpen, 'translate-x-0': sidebarOpen }">

<!-- After -->
<div class="... transform transition-transform duration-300 ease-in-out lg:translate-x-0"
     :class="{ '-translate-x-full': !sidebarOpen, 'translate-x-0': sidebarOpen }">
```

### 2. Inventory Navigation Links Not Working
**Problem**: Navigation links were using `href="#"` instead of actual routes.

**Solution**: Updated all inventory navigation links to use proper Inertia.js routes.

**File Changed**: `resources/js/Layouts/AppLayout.vue`

```vue
<!-- Before -->
<NavLink href="#" :active="false">Stock Items</NavLink>

<!-- After -->
<NavLink :href="route('stock-items.index')" :active="route().current('stock-items.*')">
    Stock Items
</NavLink>
```

---

## 🚀 Quick Start Guide

### 1. Start the Development Server

```bash
cd "Desktop/dasi pharma"
php artisan serve
```

The server will start at: **http://127.0.0.1:8000**

### 2. Login Credentials

Use these credentials to login:

- **Email**: `admin@dasipharma.ng`
- **Password**: `password`

### 3. Access Inventory Features

After logging in, you can access:

1. **Dashboard** - Overview and metrics
2. **Stock Items** - View and manage inventory batches
3. **Stock Movements** - View audit trail of all stock changes
4. **Stock Transfers** - Manage inter-branch transfers

---

## 🔍 Verification Checklist

### Server Status
- [ ] Server is running on http://127.0.0.1:8000
- [ ] No errors in terminal
- [ ] Can access login page

### Frontend Assets
- [ ] CSS is loading (check browser DevTools)
- [ ] JavaScript is loading (check browser DevTools)
- [ ] No console errors in browser

### Authentication
- [ ] Can login with credentials
- [ ] Redirects to dashboard after login
- [ ] Can logout successfully

### Sidebar Navigation
- [ ] Sidebar is visible on desktop (≥1024px)
- [ ] Sidebar can be toggled on mobile
- [ ] All navigation links are clickable
- [ ] Active route is highlighted

### Inventory Features
- [ ] Can access Stock Items page
- [ ] Can access Stock Movements page
- [ ] Can access Stock Transfers page
- [ ] Forms load correctly
- [ ] Data displays properly

---

## 🐛 Common Issues & Solutions

### Issue: Server Not Running

**Symptoms**: 
- Browser shows "This site can't be reached"
- curl returns "Connection refused"

**Solution**:
```bash
php artisan serve
```

### Issue: Assets Not Loading

**Symptoms**:
- Page looks unstyled
- Console shows 404 errors for CSS/JS files

**Solution**:
```bash
npm run build
```

### Issue: Sidebar Not Visible

**Symptoms**:
- Can't see navigation menu on desktop
- Page content is full width

**Solution**:
- Already fixed! Make sure you've run `npm run build` after the fix
- Clear browser cache (Cmd+Shift+R on Mac)

### Issue: Navigation Links Don't Work

**Symptoms**:
- Clicking inventory links does nothing
- URL doesn't change

**Solution**:
- Already fixed! Make sure you've run `npm run build` after the fix
- Clear browser cache

### Issue: Login Fails

**Symptoms**:
- "These credentials do not match our records"

**Solution**:
```bash
# Check if users exist
php artisan tinker --execute="echo App\Models\User::count();"

# If no users, run seeders
php artisan db:seed
```

### Issue: Database Errors

**Symptoms**:
- "SQLSTATE" errors
- "Table doesn't exist" errors

**Solution**:
```bash
# Run migrations
php artisan migrate

# If needed, fresh migration with seeders
php artisan migrate:fresh --seed
```

---

## 🔧 Development Commands

### Build Assets
```bash
# Production build
npm run build

# Development build with watch
npm run dev
```

### Clear Cache
```bash
# Clear all caches
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear
```

### Database
```bash
# Run migrations
php artisan migrate

# Fresh migration with seeders
php artisan migrate:fresh --seed

# Check migration status
php artisan migrate:status
```

### Routes
```bash
# List all routes
php artisan route:list

# List specific routes
php artisan route:list --path=stock
```

---

## 📊 Browser Console Checks

### Check for JavaScript Errors

1. Open browser DevTools (F12 or Cmd+Option+I)
2. Go to **Console** tab
3. Look for red error messages
4. Common errors and solutions:

**Error**: `route is not defined`
- **Solution**: Make sure Ziggy routes are loaded (check page source for Ziggy script)

**Error**: `Cannot read property 'current' of undefined`
- **Solution**: Rebuild assets with `npm run build`

**Error**: `Failed to fetch dynamically imported module`
- **Solution**: Clear browser cache and rebuild assets

### Check Network Requests

1. Open browser DevTools
2. Go to **Network** tab
3. Reload page
4. Check for:
   - ✅ All CSS files load (200 status)
   - ✅ All JS files load (200 status)
   - ✅ API requests succeed (200 status)
   - ❌ Any 404 or 500 errors

---

## 📱 Responsive Design Testing

### Desktop (≥1024px)
- Sidebar should be visible by default
- Content should have left margin for sidebar
- All features fully accessible

### Tablet (768px - 1023px)
- Sidebar hidden by default
- Hamburger menu visible
- Sidebar slides in when opened

### Mobile (<768px)
- Sidebar hidden by default
- Hamburger menu visible
- Full-screen sidebar overlay when opened

---

## 🎯 Next Steps

If everything is working:

1. ✅ Test creating a new stock item
2. ✅ Test recording a stock movement
3. ✅ Test creating a stock transfer
4. ✅ Verify FEFO sorting works
5. ✅ Check expiry warnings display correctly

If you encounter issues:

1. Check this troubleshooting guide
2. Review browser console for errors
3. Check Laravel logs: `storage/logs/laravel.log`
4. Verify database connection
5. Ensure all migrations are run

---

## 📞 Support

For additional help:
- Check Laravel logs: `tail -f storage/logs/laravel.log`
- Check browser console for JavaScript errors
- Verify all dependencies are installed: `composer install && npm install`

