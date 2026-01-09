# Action Buttons - Visual Location Guide

## 📍 Exact Button Locations

This guide shows you **exactly** where to find each action button in the Dasi Pharma interface.

---

## 🎯 Stock Items Page

### Navigation Path
1. Login to http://127.0.0.1:8000
2. Click **"Stock Items"** in the left sidebar (under Inventory section)

### Button Location
```
┌────────────────────────────────────────────────────────────────────┐
│  Sidebar │  Main Content Area                                      │
│          │                                                          │
│  [Home]  │  Stock Items                    [+ Add Stock Item]      │
│          │  Manage inventory batches with FEFO tracking            │
│  INVENTORY                                                          │
│  [Stock  │  ┌──────────────────────────────────────────────┐      │
│   Items] │  │ Search: [____________]  Expiry: [____]       │      │
│  [Stock  │  │                                               │      │
│   Moves] │  └──────────────────────────────────────────────┘      │
│  [Stock  │                                                          │
│   Trans] │  ┌──────────────────────────────────────────────┐      │
│          │  │ Drug Name    Batch    Expiry    Quantity     │      │
│          │  │ ─────────────────────────────────────────     │      │
│          │  │ (Stock items table)                          │      │
│          │  └──────────────────────────────────────────────┘      │
└────────────────────────────────────────────────────────────────────┘
```

**Button Details**:
- **Text**: "Add Stock Item"
- **Icon**: Plus sign (+)
- **Color**: Green (#16a34a)
- **Position**: Top-right corner, aligned with page title
- **Desktop**: Right side of header
- **Mobile**: Below page title

---

## 🎯 Stock Movements Page

### Navigation Path
1. Login to http://127.0.0.1:8000
2. Click **"Stock Movements"** in the left sidebar (under Inventory section)

### Button Location
```
┌────────────────────────────────────────────────────────────────────┐
│  Sidebar │  Main Content Area                                      │
│          │                                                          │
│  [Home]  │  Stock Movements              [+ Record Adjustment]     │
│          │  Complete audit trail of all inventory changes          │
│  INVENTORY                                                          │
│  [Stock  │  ┌──────────────────────────────────────────────┐      │
│   Items] │  │ Type: [____]  From: [____]  To: [____]       │      │
│  [Stock  │  │                                               │      │
│   Moves] │  └──────────────────────────────────────────────┘      │
│  [Stock  │                                                          │
│   Trans] │  ┌──────────────────────────────────────────────┐      │
│          │  │ Date    Drug/Batch    Type    Quantity  User │      │
│          │  │ ─────────────────────────────────────────     │      │
│          │  │ (Stock movements table)                      │      │
│          │  └──────────────────────────────────────────────┘      │
└────────────────────────────────────────────────────────────────────┘
```

**Button Details**:
- **Text**: "Record Adjustment"
- **Icon**: Plus sign (+)
- **Color**: Green (#16a34a)
- **Position**: Top-right corner, aligned with page title
- **Desktop**: Right side of header
- **Mobile**: Below page title

---

## 🎯 Stock Transfers Page

### Navigation Path
1. Login to http://127.0.0.1:8000
2. Click **"Stock Transfers"** in the left sidebar (under Inventory section)

### Button Location
```
┌────────────────────────────────────────────────────────────────────┐
│  Sidebar │  Main Content Area                                      │
│          │                                                          │
│  [Home]  │  Stock Transfers                  [⇄ New Transfer]      │
│          │  Manage inter-branch stock transfers                    │
│  INVENTORY                                                          │
│  [Stock  │  ┌──────────────────────────────────────────────┐      │
│   Items] │  │ Status: [____]  Direction: [____]            │      │
│  [Stock  │  │                                               │      │
│   Moves] │  └──────────────────────────────────────────────┘      │
│  [Stock  │                                                          │
│   Trans] │  ┌──────────────────────────────────────────────┐      │
│          │  │ Transfer#  From/To  Date  Status  Requester  │      │
│          │  │ ─────────────────────────────────────────     │      │
│          │  │ (Stock transfers table)                      │      │
│          │  └──────────────────────────────────────────────┘      │
└────────────────────────────────────────────────────────────────────┘
```

**Button Details**:
- **Text**: "New Transfer"
- **Icon**: Transfer arrows (⇄)
- **Color**: Green (#16a34a)
- **Position**: Top-right corner, aligned with page title
- **Desktop**: Right side of header
- **Mobile**: Below page title

---

## 📱 Responsive Behavior

### Desktop (≥640px)
```
Stock Items                              [+ Add Stock Item]
Manage inventory batches with FEFO tracking
```
- Button appears on the **same line** as the title
- Aligned to the **right**

### Mobile (<640px)
```
Stock Items
Manage inventory batches with FEFO tracking
[+ Add Stock Item]
```
- Button appears **below** the description
- Full width or left-aligned

---

## 🎨 Button Appearance

All three buttons share the same styling:

### Visual Characteristics
- **Background**: Green (#16a34a)
- **Text Color**: White
- **Border Radius**: Rounded (8px)
- **Padding**: 16px horizontal, 8px vertical
- **Font Size**: 14px
- **Font Weight**: Medium (500)
- **Icon Size**: 20px × 20px
- **Icon Position**: Left of text with 8px spacing

### Hover State
- **Background**: Darker green (#15803d)
- **Cursor**: Pointer
- **Transition**: Smooth 150ms

### Active State
- **Ring**: 2px green outline
- **Ring Offset**: 2px

---

## 🔍 How to Inspect in Browser

### Method 1: Visual Inspection
1. Open the page in your browser
2. Look at the **top-right area** of the main content
3. The button should be **immediately visible** next to the page title

### Method 2: Browser DevTools
1. Press **F12** (or Cmd+Option+I on Mac)
2. Press **Cmd+F** (or Ctrl+F) to open search
3. Search for: `Add Stock Item` or `Record Adjustment` or `New Transfer`
4. DevTools will highlight the button element

### Method 3: Elements Inspector
1. Open DevTools (F12)
2. Click the **Elements** tab
3. Click the **Select Element** tool (top-left corner)
4. Hover over the green button
5. Click to inspect its HTML

Expected HTML structure:
```html
<button type="button" class="inline-flex items-center justify-center px-4 py-2 border font-medium rounded-lg focus:outline-none focus:ring-2 focus:ring-offset-2 transition disabled:opacity-50 disabled:cursor-not-allowed border-transparent text-white bg-primary-600 hover:bg-primary-700 focus:ring-primary-500 text-sm px-4 py-2">
    <svg class="h-5 w-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path>
    </svg>
    Add Stock Item
</button>
```

---

## ✅ Verification Steps

### Step 1: Check Button Exists
1. Open browser DevTools (F12)
2. Go to **Console** tab
3. Run this command:
```javascript
document.querySelector('button:contains("Add Stock Item")')
```
4. Should return the button element (not null)

### Step 2: Check Button Visibility
1. In DevTools Console, run:
```javascript
const btn = document.querySelector('button');
const styles = window.getComputedStyle(btn);
console.log('Display:', styles.display);
console.log('Visibility:', styles.visibility);
console.log('Opacity:', styles.opacity);
```
2. All should show visible values

### Step 3: Check Button Position
1. Right-click the button
2. Select **Inspect**
3. Check the **Computed** tab in DevTools
4. Verify:
   - `display: inline-flex`
   - `background-color: rgb(22, 163, 74)` (green)
   - `color: rgb(255, 255, 255)` (white)

---

## 🐛 Common Issues

### Issue: "I don't see any button"

**Possible Causes**:
1. ❌ Not logged in
2. ❌ On wrong page
3. ❌ Browser cache showing old version
4. ❌ CSS not loaded
5. ❌ JavaScript error preventing render

**Solutions**:
```bash
# 1. Rebuild assets
npm run build

# 2. Clear browser cache
# Press Cmd+Shift+R (Mac) or Ctrl+Shift+R (Windows)

# 3. Check browser console for errors
# Press F12 → Console tab

# 4. Verify you're logged in
# Check if sidebar is visible
```

### Issue: "Button is there but looks wrong"

**Possible Causes**:
1. ❌ CSS not fully loaded
2. ❌ Tailwind classes not compiled
3. ❌ Custom colors not defined

**Solutions**:
```bash
# Rebuild with Tailwind
npm run build

# Check Tailwind config
cat tailwind.config.js | grep primary
```

### Issue: "Button doesn't do anything when clicked"

**Possible Causes**:
1. ❌ JavaScript error
2. ❌ Route not defined
3. ❌ Inertia.js not loaded

**Solutions**:
1. Check browser console for errors
2. Verify routes exist:
```bash
php artisan route:list --path=stock-items
```

---

## 📞 Still Can't Find the Button?

If you've followed all steps and still can't see the button:

1. **Take a screenshot** of the entire page
2. **Open DevTools** (F12) and take a screenshot of:
   - Console tab (showing any errors)
   - Network tab (showing loaded assets)
   - Elements tab (showing the page HTML)
3. **Check** if you see:
   - The page title ("Stock Items", etc.)
   - The description text below the title
   - The filters section below the header
   - The data table

If you see all of the above but NO button, there may be a CSS issue hiding it.

Try this in the browser console:
```javascript
// Force show all buttons
document.querySelectorAll('button').forEach(btn => {
    btn.style.display = 'inline-flex';
    btn.style.visibility = 'visible';
    btn.style.opacity = '1';
    console.log('Button text:', btn.textContent);
});
```

This will reveal any hidden buttons and log their text content.

