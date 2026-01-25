<template>
    <AppLayout>
        <!-- Page Header with Mode Toggle -->
        <div class="mb-6">
            <div class="flex items-center justify-between">
                <div>
                    <h1 class="text-2xl font-bold text-gray-900">Point of Sale (POS)</h1>
                    <p class="mt-1 text-sm text-gray-500">
                        {{ posMode === 'sale' ? 'Process new sale with FEFO stock selection' : 'Process returns and refunds' }}
                    </p>
                </div>
                <!-- Mode Toggle Tabs -->
                <div class="flex rounded-lg bg-gray-100 p-1">
                    <button
                        @click="posMode = 'sale'"
                        :class="[
                            'px-4 py-2 text-sm font-medium rounded-md transition-all',
                            posMode === 'sale'
                                ? 'bg-white text-primary-700 shadow-sm'
                                : 'text-gray-600 hover:text-gray-900'
                        ]"
                    >
                        <svg class="w-4 h-4 inline-block mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4m1.6 8L5 3H3m4 10v6a1 1 0 001 1h8a1 1 0 001-1v-6" />
                        </svg>
                        New Sale
                    </button>
                    <button
                        @click="posMode = 'return'"
                        :class="[
                            'px-4 py-2 text-sm font-medium rounded-md transition-all',
                            posMode === 'return'
                                ? 'bg-white text-orange-700 shadow-sm'
                                : 'text-gray-600 hover:text-gray-900'
                        ]"
                    >
                        <svg class="w-4 h-4 inline-block mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h10a8 8 0 018 8v2M3 10l6 6m-6-6l6-6" />
                        </svg>
                        Process Return
                    </button>
                </div>
            </div>
        </div>

        <!-- NEW SALE MODE -->
        <div v-if="posMode === 'sale'" class="grid grid-cols-1 lg:grid-cols-3 gap-6">
            <!-- Left Column: Product Selection & Cart -->
            <div class="lg:col-span-2 space-y-6">
                <!-- Product Search & Selection -->
                <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                    <h2 class="text-lg font-semibold text-gray-900 mb-4">Add Items</h2>

                    <!-- Unified Search Input -->
                    <div class="relative">
                        <div class="relative">
                            <input
                                ref="searchInputRef"
                                v-model="searchQuery"
                                type="text"
                                placeholder="Scan barcode or search by product name..."
                                class="w-full rounded-lg border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500 pl-10 pr-10 py-3 text-base"
                                @input="handleSearchInput"
                                @keydown.down.prevent="navigateDown"
                                @keydown.up.prevent="navigateUp"
                                @keydown.enter.prevent="handleEnter"
                                @keydown.esc="closeDropdown"
                                @focus="handleFocus"
                            />
                            <div class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none">
                                <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                                </svg>
                            </div>
                            <div class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none">
                                <svg v-if="isSearching" class="animate-spin h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" />
                                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z" />
                                </svg>
                                <svg v-else class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v1m6 11h2m-6 0h-2v4m0-11v3m0 0h.01M12 12h4.01M16 20h4M4 12h4m12 0h.01M5 8h2a1 1 0 001-1V5a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1zm12 0h2a1 1 0 001-1V5a1 1 0 00-1-1h-2a1 1 0 00-1 1v2a1 1 0 001 1zM5 20h2a1 1 0 001-1v-2a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1z" />
                                </svg>
                            </div>
                        </div>

                        <!-- Search Results Dropdown -->
                        <div
                            v-if="showDropdown && (searchResults.length > 0 || (searchQuery.length >= 2 && !isSearching))"
                            class="absolute z-50 mt-1 w-full bg-white rounded-lg shadow-lg max-h-80 overflow-auto border border-gray-200"
                        >
                            <div v-if="isSearching" class="p-4 text-center text-gray-500">
                                <span class="text-sm">Searching...</span>
                            </div>
                            <div v-else-if="searchResults.length === 0 && searchQuery.length >= 2" class="p-4 text-center text-gray-500">
                                <span class="text-sm">No products found</span>
                            </div>
                            <ul v-else class="py-1">
                                <li
                                    v-for="(product, index) in searchResults"
                                    :key="product.id"
                                    class="px-4 py-3 hover:bg-gray-50 cursor-pointer border-b border-gray-100 last:border-b-0"
                                    :class="{ 'bg-primary-50': index === highlightedIndex }"
                                    @click="selectProduct(product)"
                                    @mouseenter="highlightedIndex = index"
                                >
                                    <div class="flex items-center justify-between">
                                        <div class="flex-1">
                                            <div class="flex items-center gap-2">
                                                <p class="text-sm font-medium text-gray-900">{{ product.brand_name }}</p>
                                                <span
                                                    v-if="product.in_stock"
                                                    class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-green-100 text-green-800"
                                                >
                                                    {{ product.stock_available }} in stock
                                                </span>
                                                <span
                                                    v-else
                                                    class="inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-red-100 text-red-800"
                                                >
                                                    Out of Stock
                                                </span>
                                            </div>
                                            <p class="text-xs text-gray-500 mt-1">
                                                {{ product.generic_name }} • {{ product.strength }}
                                                <span v-if="product.barcode" class="text-gray-400"> • {{ product.barcode }}</span>
                                            </p>
                                        </div>
                                        <div class="text-right ml-4">
                                            <p class="text-sm font-semibold text-primary-600">₦{{ formatNumber(product.selling_price) }}</p>
                                        </div>
                                    </div>
                                </li>
                            </ul>
                        </div>

                        <p class="mt-2 text-xs text-gray-500">
                            💡 Scan barcode or type product name • Press Enter to add first result
                        </p>
                    </div>
                </div>

                <!-- Shopping Cart -->
                <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                    <h2 class="text-lg font-semibold text-gray-900 mb-4">Cart Items</h2>
                    
                    <div v-if="form.items.length === 0" class="text-center py-8 text-gray-500">
                        <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z" />
                        </svg>
                        <p class="mt-2">Cart is empty</p>
                        <p class="text-sm">Click on products to add them to cart</p>
                    </div>

                    <div v-else class="space-y-3">
                        <div
                            v-for="(item, index) in form.items"
                            :key="index"
                            class="flex items-center gap-4 p-3 border border-gray-200 rounded-lg"
                        >
                            <div class="flex-1">
                                <h3 class="text-sm font-semibold text-gray-900">{{ item.drug_name }}</h3>
                                <p class="text-xs text-gray-500">Batch: {{ item.batch_number }}</p>
                                <p class="text-xs text-gray-500">₦{{ formatNumber(item.unit_price) }} × {{ item.quantity }}</p>
                            </div>
                            <div class="flex items-center gap-2">
                                <button
                                    @click="decrementQuantity(index)"
                                    type="button"
                                    class="w-8 h-8 flex items-center justify-center rounded-md border border-gray-300 hover:bg-gray-50"
                                >
                                    <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 12H4" />
                                    </svg>
                                </button>
                                <input
                                    v-model.number="item.quantity"
                                    type="number"
                                    min="1"
                                    :max="item.max_quantity"
                                    class="w-16 text-center rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                                />
                                <button
                                    @click="incrementQuantity(index)"
                                    type="button"
                                    class="w-8 h-8 flex items-center justify-center rounded-md border border-gray-300 hover:bg-gray-50"
                                >
                                    <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                                    </svg>
                                </button>
                            </div>
                            <div class="text-right min-w-[80px]">
                                <p class="text-sm font-semibold text-gray-900">₦{{ formatNumber(item.unit_price * item.quantity) }}</p>
                            </div>
                            <button
                                @click="removeFromCart(index)"
                                type="button"
                                class="text-red-600 hover:text-red-800"
                            >
                                <svg class="h-5 w-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                                </svg>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Column: Customer Info & Payment -->
            <div class="space-y-6">
                <!-- Customer Information -->
                <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                    <h2 class="text-lg font-semibold text-gray-900 mb-4">Customer Information</h2>
                    
                    <div class="space-y-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Customer Name</label>
                            <input
                                v-model="form.customer_name"
                                type="text"
                                placeholder="Optional"
                                class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                            />
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Phone Number</label>
                            <input
                                v-model="form.customer_phone"
                                type="tel"
                                placeholder="Optional"
                                class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                            />
                        </div>
                        <div v-if="requiresPrescription">
                            <label class="block text-sm font-medium text-gray-700 mb-1">
                                Prescription Number <span class="text-red-500">*</span>
                            </label>
                            <input
                                v-model="form.prescription_number"
                                type="text"
                                placeholder="Required for Rx items"
                                class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                                :class="{ 'border-red-500': form.errors.prescription_number }"
                            />
                            <p v-if="form.errors.prescription_number" class="mt-1 text-sm text-red-600">
                                {{ form.errors.prescription_number }}
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Order Summary -->
                <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                    <h2 class="text-lg font-semibold text-gray-900 mb-4">Order Summary</h2>

                    <div class="space-y-3">
                        <div class="flex justify-between text-sm">
                            <span class="text-gray-600">Subtotal</span>
                            <span class="font-medium text-gray-900">₦{{ formatNumber(subtotal) }}</span>
                        </div>
                        <div class="flex justify-between text-sm items-center">
                            <span class="text-gray-600">Discount (%)</span>
                            <div class="flex items-center gap-2">
                                <input
                                    v-model.number="form.discount_percentage"
                                    type="number"
                                    min="0"
                                    max="100"
                                    step="0.1"
                                    placeholder="e.g., 10"
                                    class="w-24 text-right rounded-md border-gray-400 shadow-sm focus:border-primary-500 focus:ring-primary-500 text-sm"
                                    :class="{ 'border-yellow-400': requiresDiscountAuth && !discountIsAuthorized }"
                                />
                            </div>
                        </div>
                        <!-- Display calculated discount amount -->
                        <div v-if="discountAmount > 0" class="flex justify-between text-sm items-center text-gray-500">
                            <span class="text-xs">Discount Amount</span>
                            <span class="text-xs">₦{{ discountAmount.toLocaleString('en-NG', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) }}</span>
                        </div>
                        <!-- Discount Authorization Status -->
                        <div v-if="requiresDiscountAuth" class="p-3 rounded-lg" :class="discountIsAuthorized ? 'bg-green-50 border border-green-200' : 'bg-yellow-50 border border-yellow-200'">
                            <div v-if="discountIsAuthorized" class="flex items-center justify-between">
                                <div class="flex items-center text-green-700">
                                    <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                                    </svg>
                                    <span class="text-sm font-medium">Discount authorized by {{ discountAuth?.name }}</span>
                                </div>
                                <button
                                    @click="clearDiscountAuth"
                                    type="button"
                                    class="text-xs text-gray-500 hover:text-red-600"
                                    title="Clear discount"
                                >
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                                    </svg>
                                </button>
                            </div>
                            <div v-else class="text-yellow-700">
                                <p class="text-sm font-medium">Authorization required for discount</p>
                                <button
                                    @click="showDiscountAuthModal = true"
                                    type="button"
                                    class="mt-2 text-sm text-yellow-800 underline hover:no-underline"
                                >
                                    Click to authorize
                                </button>
                            </div>
                        </div>
                        <!-- VAT Display -->
                        <div v-if="vatAmount > 0" class="flex justify-between text-sm">
                            <span class="text-gray-600">
                                {{ vatConfig?.display_text || 'VAT' }} ({{ vatConfig?.rate || 0 }}%)
                            </span>
                            <span class="font-medium text-gray-900">₦{{ formatNumber(vatAmount) }}</span>
                        </div>
                        <div class="border-t border-gray-200 pt-3">
                            <div class="flex justify-between">
                                <span class="text-base font-semibold text-gray-900">Total</span>
                                <span class="text-xl font-bold text-primary-600">₦{{ formatNumber(total) }}</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Payment Methods -->
                <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                    <h2 class="text-lg font-semibold text-gray-900 mb-4">Payment</h2>

                    <div class="space-y-4">
                        <div v-for="(payment, index) in form.payments" :key="index" class="space-y-3 p-3 border border-gray-200 rounded-lg">
                            <div class="flex justify-between items-center">
                                <span class="text-sm font-medium text-gray-700">Payment {{ index + 1 }}</span>
                                <button
                                    v-if="form.payments.length > 1"
                                    @click="removePayment(index)"
                                    type="button"
                                    class="text-red-600 hover:text-red-800 text-sm"
                                >
                                    Remove
                                </button>
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">Method</label>
                                <select
                                    v-model="payment.payment_method"
                                    class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                                >
                                    <option value="">Select method</option>
                                    <option v-for="(label, value) in paymentMethods" :key="value" :value="value">
                                        {{ label }}
                                    </option>
                                </select>
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-1">Amount</label>
                                <input
                                    v-model.number="payment.amount"
                                    type="number"
                                    min="0"
                                    step="0.01"
                                    class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                                />
                            </div>
                            <div v-if="payment.payment_method && payment.payment_method !== 'cash'">
                                <label class="block text-sm font-medium text-gray-700 mb-1">Reference Number</label>
                                <input
                                    v-model="payment.reference_number"
                                    type="text"
                                    placeholder="Transaction reference"
                                    class="w-full rounded-md border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                                />
                            </div>
                        </div>

                        <button
                            @click="addPayment"
                            type="button"
                            class="w-full px-4 py-2 text-sm font-medium text-primary-600 bg-primary-50 border border-primary-200 rounded-md hover:bg-primary-100"
                        >
                            + Add Payment Method (Split Payment)
                        </button>

                        <div v-if="paymentTotal > 0" class="pt-3 border-t border-gray-200">
                            <div class="flex justify-between text-sm">
                                <span class="text-gray-600">Payment Total</span>
                                <span
                                    class="font-semibold"
                                    :class="paymentTotal === total ? 'text-green-600' : 'text-red-600'"
                                >
                                    ₦{{ formatNumber(paymentTotal) }}
                                </span>
                            </div>
                            <div v-if="paymentTotal !== total" class="mt-1 text-xs text-red-600">
                                Payment must equal total amount
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="space-y-3">
                    <Button
                        @click="submitSale"
                        :disabled="!canSubmit || form.processing"
                        class="w-full"
                    >
                        <span v-if="!form.processing">Complete Sale</span>
                        <span v-else class="flex items-center justify-center">
                            <svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                            </svg>
                            Processing...
                        </span>
                    </Button>
                    <Button
                        @click="$inertia.visit(route('sales.index'))"
                        variant="outline"
                        :disabled="form.processing"
                        class="w-full"
                    >
                        Cancel
                    </Button>
                </div>
            </div>
        </div>

        <!-- RETURN MODE -->
        <div v-else class="grid grid-cols-1 lg:grid-cols-3 gap-6">
            <!-- Left Column: Receipt Lookup & Items -->
            <div class="lg:col-span-2 space-y-6">
                <!-- Receipt Lookup -->
                <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                    <h2 class="text-lg font-semibold text-gray-900 mb-4">Lookup Receipt</h2>
                    <div class="flex gap-3">
                        <input
                            v-model="returnReceiptNumber"
                            type="text"
                            placeholder="Enter receipt number (e.g., SAL-20260108-0001)"
                            class="flex-1 rounded-lg border-gray-300 shadow-sm focus:border-orange-500 focus:ring-orange-500"
                            @keydown.enter="lookupReceipt"
                        />
                        <Button
                            @click="lookupReceipt"
                            :disabled="!returnReceiptNumber || isLookingUp"
                            variant="outline"
                        >
                            <span v-if="isLookingUp" class="flex items-center">
                                <svg class="animate-spin -ml-1 mr-2 h-4 w-4" fill="none" viewBox="0 0 24 24">
                                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"></path>
                                </svg>
                                Looking up...
                            </span>
                            <span v-else>Lookup</span>
                        </Button>
                    </div>
                    <p v-if="returnLookupError" class="mt-2 text-sm text-red-600">{{ returnLookupError }}</p>
                </div>

                <!-- Original Sale Details -->
                <div v-if="returnSale" class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
                    <div class="flex items-center justify-between mb-4">
                        <h2 class="text-lg font-semibold text-gray-900">Original Sale</h2>
                        <span class="text-sm text-gray-500">{{ returnSale.sale_date_formatted }}</span>
                    </div>

                    <div class="grid grid-cols-2 gap-4 mb-4 text-sm">
                        <div>
                            <span class="text-gray-500">Receipt:</span>
                            <span class="ml-2 font-medium">{{ returnSale.sale_number }}</span>
                        </div>
                        <div>
                            <span class="text-gray-500">Customer:</span>
                            <span class="ml-2 font-medium">{{ returnSale.customer_name }}</span>
                        </div>
                        <div>
                            <span class="text-gray-500">Cashier:</span>
                            <span class="ml-2 font-medium">{{ returnSale.cashier }}</span>
                        </div>
                        <div>
                            <span class="text-gray-500">Days Since Sale:</span>
                            <span class="ml-2 font-medium">{{ returnSale.days_since_sale }} days</span>
                        </div>
                    </div>

                    <!-- Items to Return -->
                    <h3 class="text-sm font-semibold text-gray-700 mb-3">Select Items to Return</h3>
                    <div class="space-y-3">
                        <div
                            v-for="item in returnSale.items"
                            :key="item.id"
                            class="flex items-center gap-4 p-3 rounded-lg border"
                            :class="item.can_return ? 'border-gray-200 bg-gray-50' : 'border-gray-100 bg-gray-100 opacity-60'"
                        >
                            <input
                                type="checkbox"
                                v-model="returnSelectedItems"
                                :value="item.id"
                                :disabled="!item.can_return"
                                class="h-4 w-4 text-orange-600 focus:ring-orange-500 border-gray-300 rounded"
                            />
                            <div class="flex-1 min-w-0">
                                <p class="font-medium text-gray-900 truncate">{{ item.drug_name }}</p>
                                <p class="text-xs text-gray-500">
                                    {{ item.generic_name }} {{ item.strength }} | Batch: {{ item.batch_number }}
                                </p>
                            </div>
                            <div class="text-right">
                                <p class="text-sm text-gray-600">₦{{ formatNumber(item.unit_price) }} × {{ item.quantity_purchased }}</p>
                                <p v-if="item.quantity_returned > 0" class="text-xs text-orange-600">
                                    {{ item.quantity_returned }} already returned
                                </p>
                            </div>
                            <div v-if="returnSelectedItems.includes(item.id)" class="flex items-center gap-2">
                                <label class="text-xs text-gray-500">Qty:</label>
                                <input
                                    type="number"
                                    v-model.number="returnQuantities[item.id]"
                                    :min="1"
                                    :max="item.quantity_returnable"
                                    class="w-16 text-center rounded border-gray-300 text-sm"
                                />
                                <span class="text-xs text-gray-400">/ {{ item.quantity_returnable }}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Column: Return Summary -->
            <div class="space-y-6">
                <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6 sticky top-6">
                    <h2 class="text-lg font-semibold text-gray-900 mb-4">Return Summary</h2>

                    <div v-if="!returnSale" class="text-center py-8 text-gray-500">
                        <svg class="mx-auto h-12 w-12 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                        </svg>
                        <p class="mt-2">Enter a receipt number to begin</p>
                    </div>

                    <div v-else>
                        <!-- Selected Items Summary -->
                        <div class="space-y-2 mb-4">
                            <div v-for="itemId in returnSelectedItems" :key="itemId" class="flex justify-between text-sm">
                                <span class="text-gray-600 truncate">
                                    {{ getReturnItemName(itemId) }} × {{ returnQuantities[itemId] || 1 }}
                                </span>
                                <span class="font-medium">₦{{ formatNumber(getReturnItemRefund(itemId)) }}</span>
                            </div>
                        </div>

                        <div class="border-t border-gray-200 pt-4 space-y-2">
                            <div class="flex justify-between text-lg font-bold">
                                <span>Refund Total</span>
                                <span class="text-orange-600">₦{{ formatNumber(returnRefundTotal) }}</span>
                            </div>
                        </div>

                        <!-- Return Reason -->
                        <div class="mt-4">
                            <label class="block text-sm font-medium text-gray-700 mb-1">Return Reason *</label>
                            <textarea
                                v-model="returnReason"
                                rows="2"
                                placeholder="Enter reason for return..."
                                class="w-full rounded-lg border-gray-300 shadow-sm focus:border-orange-500 focus:ring-orange-500 text-sm"
                            ></textarea>
                        </div>

                        <!-- Refund Method -->
                        <div class="mt-4">
                            <label class="block text-sm font-medium text-gray-700 mb-1">Refund Method *</label>
                            <select
                                v-model="returnRefundMethod"
                                class="w-full rounded-lg border-gray-300 shadow-sm focus:border-orange-500 focus:ring-orange-500 text-sm"
                            >
                                <option value="cash">Cash Refund</option>
                                <option value="original_payment">Original Payment Method</option>
                                <option value="store_credit">Store Credit</option>
                            </select>
                        </div>

                        <!-- Admin Authorization Status -->
                        <div class="mt-4 p-3 rounded-lg" :class="returnAdminAuth ? 'bg-green-50 border border-green-200' : 'bg-yellow-50 border border-yellow-200'">
                            <div v-if="returnAdminAuth" class="flex items-center text-green-700">
                                <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                                </svg>
                                <span class="text-sm font-medium">Authorized by {{ returnAdminAuth.name }}</span>
                            </div>
                            <div v-else class="text-yellow-700">
                                <p class="text-sm font-medium">Admin authorization required</p>
                                <button
                                    @click="showAdminAuthModal = true"
                                    class="mt-2 text-sm text-yellow-800 underline hover:no-underline"
                                >
                                    Click to authorize
                                </button>
                            </div>
                        </div>

                        <!-- Process Return Button -->
                        <div class="mt-6">
                            <Button
                                @click="processReturn"
                                :disabled="!canProcessReturn || isProcessingReturn"
                                class="w-full bg-orange-600 hover:bg-orange-700"
                            >
                                <span v-if="isProcessingReturn" class="flex items-center justify-center">
                                    <svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" fill="none" viewBox="0 0 24 24">
                                        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                                        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"></path>
                                    </svg>
                                    Processing...
                                </span>
                                <span v-else>Process Return</span>
                            </Button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Admin Authorization Modal -->
        <div v-if="showAdminAuthModal" class="fixed inset-0 z-50 overflow-y-auto">
            <div class="flex items-center justify-center min-h-screen px-4">
                <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" @click="showAdminAuthModal = false"></div>
                <div class="relative bg-white rounded-lg shadow-xl max-w-md w-full p-6">
                    <h3 class="text-lg font-semibold text-gray-900 mb-4">Admin Authorization</h3>

                    <!-- Auth Method Tabs -->
                    <div class="flex border-b border-gray-200 mb-4">
                        <button
                            @click="adminAuthMethod = 'code'"
                            class="flex-1 py-2 text-sm font-medium border-b-2 transition-colors"
                            :class="adminAuthMethod === 'code' ? 'border-orange-500 text-orange-600' : 'border-transparent text-gray-500 hover:text-gray-700'"
                        >
                            <svg class="w-4 h-4 inline mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
                            </svg>
                            PIN Code
                        </button>
                        <button
                            @click="adminAuthMethod = 'password'"
                            class="flex-1 py-2 text-sm font-medium border-b-2 transition-colors"
                            :class="adminAuthMethod === 'password' ? 'border-orange-500 text-orange-600' : 'border-transparent text-gray-500 hover:text-gray-700'"
                        >
                            <svg class="w-4 h-4 inline mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 7a2 2 0 012 2m4 0a6 6 0 01-7.743 5.743L11 17H9v2H7v2H4a1 1 0 01-1-1v-2.586a1 1 0 01.293-.707l5.964-5.964A6 6 0 1121 9z"/>
                            </svg>
                            Email/Password
                        </button>
                    </div>

                    <!-- PIN Code Method -->
                    <div v-if="adminAuthMethod === 'code'" class="space-y-4">
                        <p class="text-sm text-gray-600">Enter your 6-digit authorization code.</p>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Authorization Code</label>
                            <input
                                v-model="adminAuthCode"
                                type="password"
                                maxlength="6"
                                pattern="[0-9]{6}"
                                class="w-full rounded-lg border-gray-300 shadow-sm focus:border-orange-500 focus:ring-orange-500 text-center font-mono text-2xl tracking-widest"
                                placeholder="••••••"
                                @keydown.enter="validateAdminAuth"
                            />
                        </div>
                        <p v-if="adminAuthError" class="text-sm text-red-600">{{ adminAuthError }}</p>
                    </div>

                    <!-- Password Method -->
                    <div v-else class="space-y-4">
                        <p class="text-sm text-gray-600">Enter admin credentials to authorize this return.</p>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Admin Email</label>
                            <input
                                v-model="adminAuthEmail"
                                type="email"
                                class="w-full rounded-lg border-gray-300 shadow-sm focus:border-orange-500 focus:ring-orange-500"
                                placeholder="admin@example.com"
                            />
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Password</label>
                            <input
                                v-model="adminAuthPassword"
                                type="password"
                                class="w-full rounded-lg border-gray-300 shadow-sm focus:border-orange-500 focus:ring-orange-500"
                                @keydown.enter="validateAdminAuth"
                            />
                        </div>
                        <p v-if="adminAuthError" class="text-sm text-red-600">{{ adminAuthError }}</p>
                    </div>

                    <div class="mt-6 flex gap-3">
                        <Button
                            @click="showAdminAuthModal = false"
                            variant="outline"
                            class="flex-1"
                        >
                            Cancel
                        </Button>
                        <Button
                            @click="validateAdminAuth"
                            :disabled="(adminAuthMethod === 'code' ? adminAuthCode.length !== 6 : (!adminAuthEmail || !adminAuthPassword)) || isValidatingAdmin"
                            class="flex-1 bg-orange-600 hover:bg-orange-700"
                        >
                            {{ isValidatingAdmin ? 'Validating...' : 'Authorize' }}
                        </Button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Return Success Modal -->
        <div v-if="returnSuccessData" class="fixed inset-0 z-50 overflow-y-auto">
            <div class="flex items-center justify-center min-h-screen px-4">
                <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity"></div>
                <div class="relative bg-white rounded-lg shadow-xl max-w-md w-full p-6 text-center">
                    <div class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-green-100 mb-4">
                        <svg class="h-6 w-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                        </svg>
                    </div>
                    <h3 class="text-lg font-semibold text-gray-900 mb-2">Return Processed Successfully</h3>
                    <p class="text-sm text-gray-600 mb-4">
                        Return #{{ returnSuccessData.return_number }} has been processed.
                    </p>
                    <div class="bg-gray-50 rounded-lg p-4 mb-4">
                        <div class="flex justify-between text-sm mb-2">
                            <span class="text-gray-600">Refund Amount:</span>
                            <span class="font-bold text-orange-600">₦{{ formatNumber(returnSuccessData.refund_amount) }}</span>
                        </div>
                        <div class="flex justify-between text-sm">
                            <span class="text-gray-600">Refund Method:</span>
                            <span class="font-medium">{{ formatRefundMethod(returnSuccessData.refund_method) }}</span>
                        </div>
                    </div>
                    <Button @click="resetReturnForm" class="w-full">
                        Process Another Return
                    </Button>
                </div>
            </div>
        </div>

        <!-- Discount Authorization Modal -->
        <div v-if="showDiscountAuthModal" class="fixed inset-0 z-50 overflow-y-auto">
            <div class="flex items-center justify-center min-h-screen px-4">
                <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" @click="showDiscountAuthModal = false"></div>
                <div class="relative bg-white rounded-lg shadow-xl max-w-md w-full p-6">
                    <h3 class="text-lg font-semibold text-gray-900 mb-4">Discount Authorization</h3>
                    <p class="text-sm text-gray-600 mb-4">
                        Authorize discount of <span class="font-bold text-primary-600">{{ form.discount_percentage }}%</span>
                        (<span class="font-bold text-primary-600">₦{{ formatNumber(discountAmount) }}</span>)
                    </p>

                    <!-- Auth Method Tabs -->
                    <div class="flex border-b border-gray-200 mb-4">
                        <button
                            @click="discountAuthMethod = 'code'"
                            type="button"
                            class="flex-1 py-2 text-sm font-medium border-b-2 transition-colors"
                            :class="discountAuthMethod === 'code' ? 'border-primary-500 text-primary-600' : 'border-transparent text-gray-500 hover:text-gray-700'"
                        >
                            <svg class="w-4 h-4 inline mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
                            </svg>
                            PIN Code
                        </button>
                        <button
                            @click="discountAuthMethod = 'password'"
                            type="button"
                            class="flex-1 py-2 text-sm font-medium border-b-2 transition-colors"
                            :class="discountAuthMethod === 'password' ? 'border-primary-500 text-primary-600' : 'border-transparent text-gray-500 hover:text-gray-700'"
                        >
                            <svg class="w-4 h-4 inline mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 7a2 2 0 012 2m4 0a6 6 0 01-7.743 5.743L11 17H9v2H7v2H4a1 1 0 01-1-1v-2.586a1 1 0 01.293-.707l5.964-5.964A6 6 0 1121 9z"/>
                            </svg>
                            Email/Password
                        </button>
                    </div>

                    <!-- PIN Code Method -->
                    <div v-if="discountAuthMethod === 'code'" class="space-y-4">
                        <p class="text-sm text-gray-600">Enter your 6-digit authorization code.</p>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Authorization Code</label>
                            <input
                                v-model="discountAuthCode"
                                type="password"
                                maxlength="6"
                                pattern="[0-9]{6}"
                                class="w-full rounded-lg border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500 text-center font-mono text-2xl tracking-widest"
                                placeholder="••••••"
                                @keydown.enter="validateDiscountAuth"
                            />
                        </div>
                        <p v-if="discountAuthError" class="text-sm text-red-600">{{ discountAuthError }}</p>
                    </div>

                    <!-- Password Method -->
                    <div v-else class="space-y-4">
                        <p class="text-sm text-gray-600">Enter admin credentials to authorize this discount.</p>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Admin Email</label>
                            <input
                                v-model="discountAuthEmail"
                                type="email"
                                class="w-full rounded-lg border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                                placeholder="admin@example.com"
                            />
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Password</label>
                            <input
                                v-model="discountAuthPassword"
                                type="password"
                                class="w-full rounded-lg border-gray-300 shadow-sm focus:border-primary-500 focus:ring-primary-500"
                                @keydown.enter="validateDiscountAuth"
                            />
                        </div>
                        <p v-if="discountAuthError" class="text-sm text-red-600">{{ discountAuthError }}</p>
                    </div>

                    <div class="mt-6 flex gap-3">
                        <Button
                            @click="showDiscountAuthModal = false"
                            variant="outline"
                            class="flex-1"
                        >
                            Cancel
                        </Button>
                        <Button
                            @click="validateDiscountAuth"
                            :disabled="(discountAuthMethod === 'code' ? discountAuthCode.length !== 6 : (!discountAuthEmail || !discountAuthPassword)) || isValidatingDiscountAuth"
                            class="flex-1"
                        >
                            {{ isValidatingDiscountAuth ? 'Validating...' : 'Authorize' }}
                        </Button>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>

<script setup>
import { ref, computed, watch, onMounted, onUnmounted } from 'vue';
import { useForm, router } from '@inertiajs/vue3';
import AppLayout from '@/Layouts/AppLayout.vue';
import Button from '@/Components/Button.vue';

/**
 * IMPORTANT: Always use window.axios instead of importing axios directly.
 * The global axios instance is configured in bootstrap.js with CSRF token
 * and withCredentials settings required for Laravel's CSRF protection.
 */
const axios = window.axios;

const props = defineProps({
    stockItems: Array,
    paymentMethods: Object,
    vatConfig: {
        type: Object,
        default: () => ({ rate: 0, display_text: 'VAT' }),
    },
});

// Unified search state
const searchInputRef = ref(null);
const searchQuery = ref('');
const searchResults = ref([]);
const isSearching = ref(false);
const showDropdown = ref(false);
const highlightedIndex = ref(-1);
let debounceTimeout = null;
let lastKeyTime = 0;
let inputBuffer = '';
let isBarcodeProcessing = false; // Flag to prevent duplicate barcode scan processing

const form = useForm({
    sale_date: new Date().toISOString().slice(0, 16),
    customer_name: '',
    customer_phone: '',
    prescription_number: '',
    discount_percentage: 0,
    discount_amount: 0, // Will be calculated from percentage
    discount_authorized_by: null,
    items: [],
    payments: [
        {
            payment_method: 'cash',
            amount: 0,
            reference_number: '',
        },
    ],
});

// Discount authorization state
const discountAuth = ref(null); // { id, name, role }
const showDiscountAuthModal = ref(false);
const discountAuthMethod = ref('code'); // 'code' or 'password'
const discountAuthCode = ref('');
const discountAuthEmail = ref('');
const discountAuthPassword = ref('');
const discountAuthError = ref('');
const isValidatingDiscountAuth = ref(false);

// Watch for discount changes - clear authorization if discount is changed or cleared
watch(() => form.discount_percentage, (newVal, oldVal) => {
    // If discount was cleared, clear the authorization
    if (!newVal || newVal <= 0) {
        discountAuth.value = null;
        form.discount_authorized_by = null;
    }
    // If discount percentage changed after authorization, require re-authorization
    else if (discountAuth.value && newVal !== oldVal) {
        discountAuth.value = null;
        form.discount_authorized_by = null;
    }
});

// Use a ref to force reactivity when cart changes
const cartVersion = ref(0);

const subtotal = computed(() => {
    // Access cartVersion to ensure reactivity on cart changes
    const _ = cartVersion.value;
    return form.items.reduce((sum, item) => {
        const itemSubtotal = parseFloat(item.unit_price) * parseInt(item.quantity);
        return sum + itemSubtotal;
    }, 0);
});

// Calculate VAT amount for items that have VAT applicable
const vatAmount = computed(() => {
    const _ = cartVersion.value;
    const vatRate = props.vatConfig?.rate || 0;
    if (vatRate <= 0) return 0;

    return form.items.reduce((sum, item) => {
        if (item.vat_applicable) {
            const itemSubtotal = parseFloat(item.unit_price) * parseInt(item.quantity);
            return sum + (itemSubtotal * vatRate / 100);
        }
        return sum;
    }, 0);
});

// Calculate discount amount from percentage
const discountAmount = computed(() => {
    const percentage = parseFloat(form.discount_percentage) || 0;
    if (percentage <= 0 || percentage > 100) return 0;
    return (subtotal.value * percentage) / 100;
});

// Update form.discount_amount whenever discountAmount changes
watch(discountAmount, (newAmount) => {
    form.discount_amount = newAmount;
});

const total = computed(() => {
    return Math.max(0, subtotal.value - discountAmount.value + vatAmount.value);
});

const paymentTotal = computed(() => {
    return form.payments.reduce((sum, payment) => sum + (parseFloat(payment.amount) || 0), 0);
});

const requiresPrescription = computed(() => {
    return form.items.some(item => item.requires_prescription);
});

// Check if discount authorization is required
const requiresDiscountAuth = computed(() => {
    return (parseFloat(form.discount_percentage) || 0) > 0;
});

// Check if discount is properly authorized
const discountIsAuthorized = computed(() => {
    return !requiresDiscountAuth.value || (discountAuth.value !== null && form.discount_authorized_by !== null);
});

const canSubmit = computed(() => {
    // Use tolerance for floating point comparison
    const paymentMatches = Math.abs(paymentTotal.value - total.value) < 0.01;

    return form.items.length > 0 &&
           paymentMatches &&
           form.payments.every(p => p.payment_method && p.amount > 0) &&
           (!requiresPrescription.value || form.prescription_number) &&
           discountIsAuthorized.value;
});

// Auto-update first payment amount when total changes
watch(total, (newTotal) => {
    if (form.payments.length === 1) {
        form.payments[0].amount = newTotal;
    }
});

// Unified search handler - detects barcode vs text search
const handleSearchInput = () => {
    const now = Date.now();
    const timeDiff = now - lastKeyTime;
    lastKeyTime = now;

    // If typing very fast (< 50ms between keys), it's likely a barcode scanner
    if (timeDiff < 50 && searchQuery.value.length > 3) {
        // Accumulate in buffer for barcode detection
        clearTimeout(debounceTimeout);
        debounceTimeout = setTimeout(() => {
            // Check if it looks like a barcode (mostly numbers, 8-14 chars)
            if (/^[0-9]{8,14}$/.test(searchQuery.value)) {
                lookupBarcode(searchQuery.value);
            } else {
                performSearch();
            }
        }, 100);
        return;
    }

    clearTimeout(debounceTimeout);

    if (searchQuery.value.length < 2) {
        searchResults.value = [];
        showDropdown.value = false;
        return;
    }

    isSearching.value = true;
    showDropdown.value = true;

    debounceTimeout = setTimeout(() => {
        // Check if it looks like a barcode
        if (/^[0-9]{8,14}$/.test(searchQuery.value)) {
            lookupBarcode(searchQuery.value);
        } else {
            performSearch();
        }
    }, 300);
};

const lookupBarcode = async (barcode) => {
    // Prevent duplicate processing (scanners often send Enter key after barcode)
    if (isBarcodeProcessing) {
        return;
    }

    try {
        isBarcodeProcessing = true;
        isSearching.value = true;
        const response = await axios.get(route('products.barcode'), {
            params: { barcode: barcode }
        });

        if (response.data.success && response.data.product) {
            const product = response.data.product;
            selectProduct(product);
        } else {
            // No barcode match, try regular search
            isBarcodeProcessing = false; // Allow Enter key to process search results
            performSearch();
        }
    } catch (error) {
        console.error('Barcode lookup error:', error);
        isBarcodeProcessing = false; // Allow Enter key to process search results
        performSearch();
    } finally {
        isSearching.value = false;
        // Reset the flag after a short delay to allow for next scan
        setTimeout(() => {
            isBarcodeProcessing = false;
        }, 500);
    }
};

const performSearch = async () => {
    if (searchQuery.value.length < 2) {
        searchResults.value = [];
        return;
    }

    try {
        isSearching.value = true;
        const response = await axios.get(route('products.autocomplete'), {
            params: {
                query: searchQuery.value,
                limit: 10,
            },
        });

        if (response.data.success) {
            searchResults.value = response.data.products;
            highlightedIndex.value = -1;
        }
    } catch (error) {
        console.error('Search error:', error);
        searchResults.value = [];
    } finally {
        isSearching.value = false;
    }
};

const selectProduct = (product) => {
    // Find the stock item from the product
    if (product.stock_item || product.in_stock) {
        const stockItemData = product.stock_item || {};
        const fullStockItem = props.stockItems?.find(item => item.id === stockItemData.id);

        if (fullStockItem) {
            addToCart(fullStockItem);
        } else {
            // Create a stock item object from the product data
            const stockItem = {
                id: stockItemData.id || product.id,
                drug_name: product.brand_name,
                generic_name: product.generic_name,
                strength: product.strength,
                dosage_form: product.dosage_form,
                batch_number: stockItemData.batch_number || 'N/A',
                quantity_available: product.stock_available || stockItemData.quantity_available || 0,
                selling_price: parseFloat(product.selling_price || stockItemData.selling_price || 0),
                requires_prescription: product.requires_prescription || false,
            };
            addToCart(stockItem);
        }

        // Clear and reset
        searchQuery.value = '';
        searchResults.value = [];
        closeDropdown();
    } else {
        alert('Product found but no stock available in this branch');
    }
};

const handleFocus = () => {
    if (searchQuery.value.length >= 2 && searchResults.value.length > 0) {
        showDropdown.value = true;
    }
};

const navigateDown = () => {
    if (highlightedIndex.value < searchResults.value.length - 1) {
        highlightedIndex.value++;
    }
};

const navigateUp = () => {
    if (highlightedIndex.value > 0) {
        highlightedIndex.value--;
    }
};

const handleEnter = () => {
    // Skip if barcode is already being processed (scanner sends Enter after barcode)
    if (isBarcodeProcessing) {
        return;
    }

    if (highlightedIndex.value >= 0 && highlightedIndex.value < searchResults.value.length) {
        selectProduct(searchResults.value[highlightedIndex.value]);
    } else if (searchResults.value.length > 0) {
        // Select first result
        selectProduct(searchResults.value[0]);
    } else if (/^[0-9]{8,14}$/.test(searchQuery.value)) {
        // Try barcode lookup
        lookupBarcode(searchQuery.value);
    }
};

const closeDropdown = () => {
    showDropdown.value = false;
    highlightedIndex.value = -1;
};

// Close dropdown when clicking outside
const handleClickOutside = (event) => {
    if (searchInputRef.value && !searchInputRef.value.contains(event.target)) {
        closeDropdown();
    }
};

onMounted(() => {
    document.addEventListener('click', handleClickOutside);
    // Focus search input on mount
    searchInputRef.value?.focus();
});

onUnmounted(() => {
    document.removeEventListener('click', handleClickOutside);
});

const addToCart = (stockItem) => {
    // Check if item already in cart
    const existingIndex = form.items.findIndex(item => item.stock_item_id === stockItem.id);

    if (existingIndex !== -1) {
        // Increment quantity if not exceeding available stock
        const currentItem = form.items[existingIndex];
        if (currentItem.quantity < currentItem.max_quantity) {
            currentItem.quantity++;
            currentItem.subtotal = parseFloat(currentItem.unit_price) * parseInt(currentItem.quantity);
        }
    } else {
        // Add new item to cart
        const unitPrice = parseFloat(stockItem.selling_price) || 0;
        form.items.push({
            stock_item_id: stockItem.id,
            drug_name: stockItem.drug_name,
            batch_number: stockItem.batch_number,
            quantity: 1,
            max_quantity: stockItem.quantity_available,
            unit_price: unitPrice,
            subtotal: unitPrice,
            vat_applicable: stockItem.vat_applicable || false,
            requires_prescription: stockItem.requires_prescription,
        });
    }
    // Trigger reactivity for computed properties
    cartVersion.value++;
};

const removeFromCart = (index) => {
    form.items.splice(index, 1);
    // Trigger reactivity for computed properties
    cartVersion.value++;
};

const incrementQuantity = (index) => {
    const item = form.items[index];
    if (item.quantity < item.max_quantity) {
        item.quantity++;
        item.subtotal = parseFloat(item.unit_price) * parseInt(item.quantity);
        // Trigger reactivity for computed properties
        cartVersion.value++;
    }
};

const decrementQuantity = (index) => {
    const item = form.items[index];
    if (item.quantity > 1) {
        item.quantity--;
        item.subtotal = parseFloat(item.unit_price) * parseInt(item.quantity);
        // Trigger reactivity for computed properties
        cartVersion.value++;
    }
};

const addPayment = () => {
    form.payments.push({
        payment_method: '',
        amount: 0,
        reference_number: '',
    });
};

const removePayment = (index) => {
    form.payments.splice(index, 1);
};

const submitSale = () => {
    // Prepare items data for submission
    const itemsData = form.items.map(item => ({
        stock_item_id: item.stock_item_id,
        quantity: item.quantity,
    }));

    form.transform((data) => ({
        ...data,
        items: itemsData,
    })).post(route('sales.store'), {
        onSuccess: () => {
            // Redirect handled by controller
        },
    });
};

// Validate discount authorization
const validateDiscountAuth = async () => {
    // Validate based on auth method
    if (discountAuthMethod.value === 'code') {
        if (discountAuthCode.value.length !== 6) return;
    } else {
        if (!discountAuthEmail.value || !discountAuthPassword.value) return;
    }

    isValidatingDiscountAuth.value = true;
    discountAuthError.value = '';

    try {
        const payload = discountAuthMethod.value === 'code'
            ? { auth_method: 'code', authorization_code: discountAuthCode.value }
            : { auth_method: 'password', email: discountAuthEmail.value, password: discountAuthPassword.value };

        const response = await axios.post(route('sales.validate-discount-auth'), payload);

        if (response.data.success) {
            discountAuth.value = response.data.admin;
            form.discount_authorized_by = response.data.admin.id;
            showDiscountAuthModal.value = false;
            // Reset all auth fields
            discountAuthCode.value = '';
            discountAuthEmail.value = '';
            discountAuthPassword.value = '';
        } else {
            discountAuthError.value = response.data.message;
        }
    } catch (error) {
        discountAuthError.value = error.response?.data?.message || 'Authentication failed.';
    } finally {
        isValidatingDiscountAuth.value = false;
    }
};

// Clear discount authorization
const clearDiscountAuth = () => {
    discountAuth.value = null;
    form.discount_authorized_by = null;
    form.discount_percentage = 0;
    form.discount_amount = 0;
};

const formatNumber = (number) => {
    return parseFloat(number || 0).toLocaleString('en-NG', {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2,
    });
};

// ============================================
// RETURN MODE STATE AND METHODS
// ============================================

const posMode = ref('sale');

// Return lookup state
const returnReceiptNumber = ref('');
const returnSale = ref(null);
const isLookingUp = ref(false);
const returnLookupError = ref('');

// Return items state
const returnSelectedItems = ref([]);
const returnQuantities = ref({});

// Return form state
const returnReason = ref('');
const returnRefundMethod = ref('cash');

// Admin auth state
const showAdminAuthModal = ref(false);
const adminAuthMethod = ref('code'); // 'code' or 'password'
const adminAuthCode = ref('');
const adminAuthEmail = ref('');
const adminAuthPassword = ref('');
const adminAuthError = ref('');
const isValidatingAdmin = ref(false);
const returnAdminAuth = ref(null);

// Processing state
const isProcessingReturn = ref(false);
const returnSuccessData = ref(null);

// Computed: refund total
const returnRefundTotal = computed(() => {
    if (!returnSale.value) return 0;
    return returnSelectedItems.value.reduce((sum, itemId) => {
        return sum + getReturnItemRefund(itemId);
    }, 0);
});

// Computed: can process return
const canProcessReturn = computed(() => {
    return returnSale.value &&
        returnSelectedItems.value.length > 0 &&
        returnReason.value.trim() &&
        returnRefundMethod.value &&
        returnAdminAuth.value;
});

// Initialize quantities when items are selected
watch(returnSelectedItems, (newItems, oldItems) => {
    newItems.forEach(itemId => {
        if (!returnQuantities.value[itemId]) {
            const item = returnSale.value?.items.find(i => i.id === itemId);
            returnQuantities.value[itemId] = item?.quantity_returnable || 1;
        }
    });
});

// Lookup receipt
const lookupReceipt = async () => {
    if (!returnReceiptNumber.value) return;

    isLookingUp.value = true;
    returnLookupError.value = '';
    returnSale.value = null;
    returnSelectedItems.value = [];
    returnQuantities.value = {};
    returnAdminAuth.value = null;

    try {
        const response = await axios.post(route('sales.lookup-for-return'), {
            receipt_number: returnReceiptNumber.value.trim(),
        });

        if (response.data.success) {
            returnSale.value = response.data.sale;
        } else {
            returnLookupError.value = response.data.message;
        }
    } catch (error) {
        returnLookupError.value = error.response?.data?.message || 'Failed to lookup receipt.';
    } finally {
        isLookingUp.value = false;
    }
};

// Get item name for summary
const getReturnItemName = (itemId) => {
    const item = returnSale.value?.items.find(i => i.id === itemId);
    return item?.drug_name || 'Unknown';
};

// Get item refund amount
const getReturnItemRefund = (itemId) => {
    const item = returnSale.value?.items.find(i => i.id === itemId);
    if (!item) return 0;
    const qty = returnQuantities.value[itemId] || 1;
    return item.unit_price * qty;
};

// Validate admin credentials
const validateAdminAuth = async () => {
    // Validate based on auth method
    if (adminAuthMethod.value === 'code') {
        if (adminAuthCode.value.length !== 6) return;
    } else {
        if (!adminAuthEmail.value || !adminAuthPassword.value) return;
    }

    isValidatingAdmin.value = true;
    adminAuthError.value = '';

    try {
        const payload = adminAuthMethod.value === 'code'
            ? { auth_method: 'code', authorization_code: adminAuthCode.value }
            : { auth_method: 'password', email: adminAuthEmail.value, password: adminAuthPassword.value };

        const response = await axios.post(route('sales.validate-admin'), payload);

        if (response.data.success) {
            returnAdminAuth.value = response.data.admin;
            showAdminAuthModal.value = false;
            // Reset all auth fields
            adminAuthCode.value = '';
            adminAuthEmail.value = '';
            adminAuthPassword.value = '';
        } else {
            adminAuthError.value = response.data.message;
        }
    } catch (error) {
        adminAuthError.value = error.response?.data?.message || 'Authentication failed.';
    } finally {
        isValidatingAdmin.value = false;
    }
};

// Process return
const processReturn = async () => {
    if (!canProcessReturn.value) return;

    isProcessingReturn.value = true;

    try {
        const items = returnSelectedItems.value.map(itemId => ({
            sale_item_id: itemId,
            quantity: returnQuantities.value[itemId] || 1,
        }));

        const response = await axios.post(route('sales.process-return'), {
            sale_id: returnSale.value.id,
            admin_id: returnAdminAuth.value.id,
            reason: returnReason.value,
            refund_method: returnRefundMethod.value,
            items: items,
        });

        if (response.data.success) {
            returnSuccessData.value = response.data.return;
        } else {
            alert(response.data.message || 'Failed to process return.');
        }
    } catch (error) {
        alert(error.response?.data?.message || 'Failed to process return.');
    } finally {
        isProcessingReturn.value = false;
    }
};

// Format refund method for display
const formatRefundMethod = (method) => {
    const methods = {
        cash: 'Cash Refund',
        original_payment: 'Original Payment Method',
        store_credit: 'Store Credit',
    };
    return methods[method] || method;
};

// Reset return form
const resetReturnForm = () => {
    returnSuccessData.value = null;
    returnReceiptNumber.value = '';
    returnSale.value = null;
    returnSelectedItems.value = [];
    returnQuantities.value = {};
    returnReason.value = '';
    returnRefundMethod.value = 'cash';
    returnAdminAuth.value = null;
};
</script>


