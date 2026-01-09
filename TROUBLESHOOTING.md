# Troubleshooting Guide - Dasi Pharma Management System

## Common Issues and Solutions

### 1. Login Issues

#### Issue: "Sign in" button not visible
**Cause**: CSS not loading or JavaScript not executing
**Solution**:
1. Rebuild assets: `npm run build`
2. Clear browser cache (Cmd+Shift+R on Mac, Ctrl+Shift+R on Windows)
3. Check browser console for JavaScript errors

#### Issue: 419 Page Expired Error
**Cause**: CSRF token mismatch or session issues
**Solution**:
1. Clear application cache: `php artisan cache:clear`
2. Clear config cache: `php artisan config:clear`
3. Ensure session driver is set to 'file' in `.env`
4. Check that `storage/framework/sessions` directory is writable
5. Use `php artisan serve` instead of `php -S` for better session handling

#### Issue: Login redirects to /home (404 error)
**Cause**: Default Laravel redirect path
**Solution**: Already fixed - routes redirect to `/dashboard`

### 2. Dashboard Errors

#### Issue: 500 Error on Dashboard
**Cause**: Missing model scopes or database query errors
**Solution**:
1. Check Laravel logs: `tail -50 storage/logs/laravel.log`
2. Verify all model scopes exist (lowStock, completed, pending, etc.)
3. Ensure database has seeded data

#### Issue: "Call to undefined method lowStock()"
**Cause**: Missing scope in StockItem model
**Solution**: Already fixed - `lowStock()` scope added to StockItem model

#### Issue: Metrics showing zero or incorrect data
**Cause**: No data in database or incorrect branch assignment
**Solution**:
1. Run seeders: `php artisan db:seed`
2. Verify user has a branch assigned
3. Check that stock items and sales exist for the user's branch

### 3. Asset Loading Issues

#### Issue: Styles not applying (Tailwind classes not working)
**Cause**: Tailwind CSS v4 configuration issues
**Solution**:
1. Ensure `@tailwindcss/postcss` is installed
2. Verify `postcss.config.js` uses `@tailwindcss/postcss`
3. Check `resources/css/app.css` has `@import "tailwindcss";`
4. Rebuild: `npm run build`

#### Issue: Vue components not rendering
**Cause**: Vite build errors or Inertia.js configuration
**Solution**:
1. Check browser console for errors
2. Verify `resources/js/app.js` is configured correctly
3. Ensure all Vue components are in `resources/js/Pages/` or `resources/js/Components/`
4. Rebuild: `npm run build`

### 4. Server Issues

#### Issue: Server not starting
**Cause**: Port already in use or PHP errors
**Solution**:
1. Kill existing process: `lsof -ti:8000 | xargs kill -9`
2. Use different port: `php artisan serve --port=8001`
3. Check PHP version: `php -v` (requires PHP 8.1+)

#### Issue: Assets not loading (404 on /build/assets/*)
**Cause**: Assets not built or Vite manifest missing
**Solution**:
1. Build assets: `npm run build`
2. Check `public/build/manifest.json` exists
3. Verify `vite.config.js` is configured correctly

### 5. Database Issues

#### Issue: Database connection errors
**Cause**: Incorrect database credentials or database not created
**Solution**:
1. Verify `.env` database settings
2. Create database: `php artisan db:create` or manually
3. Run migrations: `php artisan migrate`
4. Seed data: `php artisan db:seed`

#### Issue: Foreign key constraint errors
**Cause**: Seeding order or missing parent records
**Solution**:
1. Fresh migration: `php artisan migrate:fresh --seed`
2. Check seeder order in `DatabaseSeeder.php`

## Development Workflow

### Starting the Application

1. **Start the server**:
   ```bash
   php artisan serve
   ```

2. **For development with hot reload**:
   ```bash
   npm run dev
   ```
   Then in another terminal:
   ```bash
   php artisan serve
   ```

3. **Access the application**:
   - URL: http://127.0.0.1:8000
   - Login: http://127.0.0.1:8000/login

### Demo Credentials

- **Admin**: admin@dasipharma.ng / password
- **Pharmacist**: adebayo@dasipharma.ng / password
- **Cashier**: chioma@dasipharma.ng / password

### Checking Logs

**Laravel Logs**:
```bash
tail -f storage/logs/laravel.log
```

**Server Output**:
The `php artisan serve` command shows real-time request logs

**Browser Console**:
Open Developer Tools (F12) → Console tab

## Quick Fixes

### Clear All Caches
```bash
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear
```

### Rebuild Assets
```bash
npm run build
```

### Fresh Start
```bash
php artisan migrate:fresh --seed
npm run build
php artisan serve
```

### Check Application Status
```bash
# Check routes
php artisan route:list

# Check database connection
php artisan tinker
>>> DB::connection()->getPdo();

# Check users
php artisan tinker
>>> App\Models\User::count();
```

## Known Issues

1. **Sanctum Deprecation Warning**: 
   - Warning about `HasApiTokens::createToken()` parameter
   - Does not affect functionality
   - Will be fixed in future Laravel/Sanctum update

2. **Built-in PHP Server Limitations**:
   - Use `php artisan serve` instead of `php -S`
   - Better session handling
   - Better error reporting

## Getting Help

If you encounter issues not covered here:

1. Check Laravel logs: `storage/logs/laravel.log`
2. Check browser console for JavaScript errors
3. Verify all dependencies are installed: `composer install && npm install`
4. Ensure database is migrated and seeded
5. Try a fresh build: `npm run build`

## Performance Tips

1. **Production Build**:
   ```bash
   npm run build
   ```
   This creates optimized, minified assets

2. **Development Mode**:
   ```bash
   npm run dev
   ```
   This enables hot module replacement for faster development

3. **Optimize Laravel**:
   ```bash
   php artisan config:cache
   php artisan route:cache
   php artisan view:cache
   ```
   (Only for production, not during development)

