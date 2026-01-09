# Quick Start Guide - Enhanced Inventory System

## 🚀 Getting Started

### 1. Database Setup
```bash
# Run migrations
php artisan migrate

# Seed categories and sample products
php artisan db:seed --class=CategorySeeder
php artisan db:seed --class=SampleProductSeeder
```

### 2. Build Assets
```bash
# Development
npm run dev

# Production
npm run build
```

### 3. Start Servers
```bash
# Terminal 1: Laravel
php artisan serve --port=8001

# Terminal 2: Vite (if in dev mode)
npm run dev
```

---

## 📦 Sample Products Available

After running the seeders, you'll have 12 sample products:

### Pharmaceuticals
1. **Amoxil** - Amoxicillin 500mg Capsule
   - Barcode: `5060340394356`
   - Stock: 500 units
   - Price: ₦150.00

2. **Panadol** - Paracetamol 500mg Tablet
   - Barcode: `5012345678901`
   - Stock: 1000 units
   - Price: ₦50.00

### Vitamins & Supplements
3. **Centrum** - Multivitamin Tablet
   - Barcode: `3574661234567`
   - Stock: 300 units
   - Price: ₦500.00

4. **Feroglobin** - Iron Supplement Capsule
   - Barcode: `5021265222407`
   - Stock: 200 units
   - Price: ₦350.00

### Medical Devices
5. **Omron Digital Thermometer**
   - Barcode: `4015672123456`
   - Stock: 50 units
   - Price: ₦2,500.00

6. **Accu-Chek Blood Glucose Monitor**
   - Barcode: `4015630987654`
   - Stock: 30 units
   - Price: ₦8,500.00

### Personal Care
7. **Nivea Soft Moisturizing Cream**
   - Barcode: `4005900123456`
   - Stock: 150 units
   - Price: ₦800.00

8. **Colgate Total Toothpaste**
   - Barcode: `6920354812345`
   - Stock: 200 units
   - Price: ₦450.00

### Baby & Mother Care
9. **SMA Gold Infant Formula**
   - Barcode: `5000329123456`
   - Stock: 100 units
   - Price: ₦3,500.00

10. **Pampers Baby Dry Diapers**
    - Barcode: `4015400123456`
    - Stock: 80 units
    - Price: ₦4,200.00

### Food & Beverages
11. **Ensure Plus Nutrition Shake**
    - Barcode: `8710428123456`
    - Stock: 120 units
    - Price: ₦1,200.00

12. **Glucerna Diabetic Shake**
    - Barcode: `8710428987654`
    - Stock: 90 units
    - Price: ₦1,500.00

---

## 🔍 Testing the Autocomplete Feature

### Using ProductAutocomplete Component

1. **Navigate to any page with the component** (e.g., Stock Items → Create)

2. **Search by Product Name:**
   - Type: `amox` → See Amoxil results
   - Type: `panadol` → See Panadol results
   - Type: `centrum` → See Centrum results

3. **Search by Category:**
   - Type: `pharma` → See all pharmaceutical products
   - Type: `vitamin` → See all vitamins and supplements
   - Type: `baby` → See all baby care products

4. **Search by Generic Name:**
   - Type: `paracetamol` → See Panadol
   - Type: `amoxicillin` → See Amoxil

5. **Keyboard Navigation:**
   - Type to search
   - Press `↓` to move down results
   - Press `↑` to move up results
   - Press `Enter` to select highlighted item
   - Press `Esc` to close dropdown

---

## 📟 Testing Barcode Scanning

### Using BarcodeInput Component

1. **Manual Entry:**
   - Click in the barcode field
   - Type: `5060340394356` (Amoxil)
   - Press Enter
   - Product should be found

2. **USB Scanner (if available):**
   - Click in the barcode field
   - Scan any product barcode
   - System auto-detects scanner input
   - Shows "Barcode detected!" indicator
   - Product loads automatically

3. **Test Barcodes:**
   ```
   5060340394356 - Amoxil
   5012345678901 - Panadol
   3574661234567 - Centrum
   4015672123456 - Omron Thermometer
   8710428123456 - Ensure Shake
   ```

---

## 🧪 Testing API Endpoints

### 1. Autocomplete Search
```bash
# Search for products
curl "http://localhost:8001/api/products/autocomplete?query=amox"

# Expected response:
{
  "success": true,
  "products": [
    {
      "id": 1,
      "brand_name": "Amoxil",
      "generic_name": "Amoxicillin",
      "strength": "500mg",
      "dosage_form": "Capsule",
      "barcode": "5060340394356",
      "category": "Pharmaceuticals",
      "subcategory": "Antibiotics",
      "in_stock": true,
      "stock_available": 500,
      "selling_price": "150.00"
    }
  ]
}
```

### 2. Barcode Lookup
```bash
# Look up product by barcode
curl "http://localhost:8001/api/products/barcode?barcode=5060340394356"

# Expected response:
{
  "success": true,
  "product": {
    "id": 1,
    "brand_name": "Amoxil",
    "generic_name": "Amoxicillin",
    "barcode": "5060340394356",
    "stock_item": {
      "id": 1,
      "quantity_available": 500,
      "selling_price": "150.00"
    }
  }
}
```

### 3. Get Categories
```bash
# Get all categories with subcategories
curl "http://localhost:8001/api/categories"
```

---

## 📊 Categories Available

1. **Pharmaceuticals**
   - Antibiotics
   - Pain Relief
   - Cardiovascular
   - Respiratory
   - Gastrointestinal

2. **Vitamins & Supplements**
   - Multivitamins
   - Minerals
   - Herbal Supplements
   - Protein & Fitness

3. **Medical Devices**
   - Diagnostic Tools
   - First Aid
   - Mobility Aids

4. **Personal Care**
   - Skin Care
   - Oral Care
   - Hair Care

5. **Baby & Mother Care**
   - Baby Food
   - Diapers & Wipes
   - Maternal Health

6. **Food & Beverages**
   - Health Drinks
   - Diabetic Foods
   - Organic Foods

---

## 🎯 Common Use Cases

### Use Case 1: Quick Product Lookup
1. Start typing product name in autocomplete
2. See real-time results with stock info
3. Select product to auto-populate details

### Use Case 2: Barcode Scanning
1. Click barcode input field
2. Scan product with USB scanner
3. Product details load instantly
4. Add to cart/inventory

### Use Case 3: Browse by Category
1. Select category from dropdown
2. Subcategories filter automatically
3. Products filter by selection

---

## 🐛 Troubleshooting

### Autocomplete Not Working
- Check browser console for errors
- Verify API endpoint is accessible
- Ensure minimum 2 characters entered
- Check network tab for API responses

### Barcode Scanner Not Detected
- Verify scanner is in keyboard emulation mode
- Test scanner in a text editor first
- Check scanner speed settings
- Try manual entry to test barcode lookup

### No Products Showing
- Run seeders: `php artisan db:seed --class=SampleProductSeeder`
- Check database: `php artisan tinker` → `Drug::count()`
- Verify migrations ran successfully

### Build Errors
- Clear cache: `npm run build`
- Delete node_modules and reinstall: `rm -rf node_modules && npm install`
- Check for syntax errors in Vue components

---

## 📞 Support

For issues or questions:
1. Check `ENHANCED_INVENTORY_BARCODE_SYSTEM.md` for detailed documentation
2. Review browser console for JavaScript errors
3. Check Laravel logs: `storage/logs/laravel.log`
4. Verify database migrations and seeders ran successfully

---

**Last Updated**: January 7, 2026
**Version**: 1.0.0

