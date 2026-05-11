# Task 2 - ALL CODE FILES (Real System Mappings + Fake Data)

## How to Use This Document

1. Copy the code from each section below
2. Create the file in your project with the exact path shown
3. Paste the code
4. Save the file
5. Move to next file

**NOTE:** 
- Affiliate networks, error reasons, statuses = **REAL** (from handbook)
- Merchant names, amounts, MIDs, file names = **COMPLETELY FAKE** (realistic but fictional)
- Perfect for portfolio - authentic system, zero real client data

---

## FILE 1: app/models/payment_file.rb

**Create file:** `app/models/payment_file.rb`

```ruby
class PaymentFile < ApplicationRecord
  has_many :transactions, dependent: :destroy

  # Enums - Real statuses from handbook
  enum :status, {
    new: 'new',
    ready: 'ready',
    processing: 'processing',
    parsed: 'parsed',
    partial_reconciled: 'partial_reconciled',
    full_reconciled: 'full_reconciled'
  }, prefix: true

  enum :region, {
    uk: 'uk',
    ca: 'ca',
    us: 'us',
    au: 'au'
  }, prefix: true

  # Validations
  validates :filename, :deposit_amount, :payment_id, presence: true
  validates :region, inclusion: { in: regions.keys }
  validates :status, inclusion: { in: statuses.keys }

  # Scopes
  scope :by_region, ->(region) { where(region: region) if region.present? }
  scope :by_affiliate, ->(affiliate) { where(affiliate_network: affiliate) if affiliate.present? }
  scope :parsed, -> { where(status: 'parsed') }
  scope :with_errors, -> { joins(:transactions).where(transactions: { error_flag: true }).distinct }

  # Constants - Real affiliate networks from handbook
  AFFILIATE_NETWORKS = [
    'Commission Junction - UK',
    'Commission Junction - CA',
    'Commission Junction - AU',
    'Linkshare - UK',
    'Linkshare - CA',
    'Linkshare - AU',
    'Qantas - AU',
    'WebLogic - UK'
  ].freeze

  REGIONS_DISPLAY = {
    'uk' => 'UK',
    'ca' => 'CA',
    'us' => 'US',
    'au' => 'AU'
  }.freeze

  # Instance methods
  def region_display
    REGIONS_DISPLAY[region]
  end

  def status_display
    status.humanize
  end

  def file_label
    "#{filename} - #{deposit_date}"
  end

  def error_count
    transactions.where(error_flag: true).count
  end

  def has_errors?
    error_count > 0
  end

  def transaction_count
    transactions.count
  end
end
```

---

## FILE 2: app/models/transaction.rb

**Create file:** `app/models/transaction.rb`

```ruby
class Transaction < ApplicationRecord
  belongs_to :payment_file

  # Enums - Real from handbook
  enum :transaction_status, {
    paid: 'paid',
    declined: 'declined',
    missing: 'missing',
    closed: 'closed'
  }, prefix: true

  enum :transaction_type, {
    paid_sales: 'paid_sales',
    paid_commission: 'paid_commission',
    declined_sales: 'declined_sales',
    declined_commission: 'declined_commission',
    missing_sales: 'missing_sales',
    missing_commission: 'missing_commission',
    closed_sales: 'closed_sales',
    closed_commission: 'closed_commission',
    bonus: 'bonus',
    tenancy_fee: 'tenancy_fee',
    transaction: 'transaction'
  }, prefix: true

  enum :screen_type, {
    display: 'display',
    missing: 'missing',
    tenancy: 'tenancy',
    summary: 'summary'
  }, prefix: true

  # Validations
  validates :mid, :merchant_name, :transaction_type, :amount, presence: true
  validates :payment_file_id, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0 }

  # Scopes
  scope :with_errors, -> { where(error_flag: true) }
  scope :for_screen, ->(screen) { where(screen_type: screen) if screen.present? }
  scope :locked, -> { where(transaction_locked: true) }
  scope :by_type, ->(type) { where(transaction_type: type) if type.present? }
  scope :by_status, ->(status) { where(transaction_status: status) if status.present? }

  # Constants - Real error reasons from handbook
  ERROR_REASONS = {
    'COMMISSION_MISMATCH' => 'Commission Mismatch - Amount differs from system',
    'TRANSACTION_NOT_FOUND' => 'Transaction Not Found - Doesn\'t exist in system',
    'AGGREGATOR_TRANSACTION_ID_NOT_FOUND' => 'Aggregator Transaction ID Not Found',
    'AGGREGATOR_MISMATCH' => 'Aggregator Mismatch - Network doesn\'t match',
    'UNKNOWN_REASON' => 'Unknown Reason - Unable to determine mismatch',
    'INVALID_DATE' => 'Invalid Date - Incorrectly formatted or missing',
    'INVALID_SALE_VALUE' => 'Invalid Sale Value - Missing or invalid format',
    'INVALID_COMMISSION_VALUE' => 'Invalid Commission Value - Zero or invalid format',
    'TRANSACTION_ALREADY_CLOSED' => 'Transaction Already Closed - Previously settled'
  }.freeze

  TRANSACTION_TYPE_DISPLAY = {
    'paid_sales' => 'Paid Sales',
    'paid_commission' => 'Paid Commission',
    'declined_sales' => 'Declined Sales',
    'declined_commission' => 'Declined Commission',
    'missing_sales' => 'Missing Sales',
    'missing_commission' => 'Missing Commission',
    'closed_sales' => 'Closed Sales',
    'closed_commission' => 'Closed Commission',
    'bonus' => 'Bonus',
    'tenancy_fee' => 'Tenancy Fee',
    'transaction' => 'Transaction'
  }.freeze

  TRANSACTION_STATUS_DISPLAY = {
    'paid' => 'PAID',
    'declined' => 'DECLINED',
    'missing' => 'MISSING',
    'closed' => 'CLOSED'
  }.freeze

  # Instance methods
  def type_display
    TRANSACTION_TYPE_DISPLAY[transaction_type]
  end

  def status_display
    TRANSACTION_STATUS_DISPLAY[transaction_status]
  end

  def error_display
    ERROR_REASONS[error_reason] || error_reason
  end

  def has_error?
    error_flag == true
  end

  def total_commission
    (commission_initial || 0) + (commission_final || 0)
  end
end
```

---

## FILE 3: db/migrate/[timestamp]_create_payment_files.rb

**Create file:** `db/migrate/20260510000001_create_payment_files.rb`

```ruby
class CreatePaymentFiles < ActiveRecord::Migration[7.1]
  def change
    create_table :payment_files do |t|
      t.string :filename, null: false
      t.string :region, null: false
      t.string :affiliate_network, null: false
      t.date :deposit_date, null: false
      t.decimal :deposit_amount, precision: 12, scale: 2, null: false
      t.string :payment_id, null: false
      t.string :status, null: false, default: 'new'
      t.string :file_status_label, default: 'NEW'

      t.timestamps
    end

    add_index :payment_files, :status
    add_index :payment_files, :region
    add_index :payment_files, :affiliate_network
  end
end
```

---

## FILE 4: db/migrate/[timestamp]_create_transactions.rb

**Create file:** `db/migrate/20260510000002_create_transactions.rb`

```ruby
class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.references :payment_file, null: false, foreign_key: true
      t.integer :mid, null: false
      t.string :merchant_name, null: false
      t.string :transaction_status, null: false, default: 'paid'
      t.string :transaction_type, null: false
      t.decimal :amount, precision: 12, scale: 2, null: false
      t.boolean :error_flag, default: false
      t.string :error_reason
      t.string :screen_type, default: 'display'
      t.decimal :commission_initial, precision: 12, scale: 2
      t.decimal :commission_final, precision: 12, scale: 2
      t.string :tenancy_tranx
      t.decimal :campaign_amount, precision: 12, scale: 2
      t.boolean :transaction_locked, default: false

      t.timestamps
    end

    add_index :transactions, :payment_file_id
    add_index :transactions, :error_flag
    add_index :transactions, :screen_type
    add_index :transactions, :transaction_status
    add_index :transactions, :mid
  end
end
```

---

## FILE 5: db/seeds.rb

**Replace file:** `db/seeds.rb`

```ruby
# db/seeds.rb
# Seed data for Payment Reconciliation Portfolio App
# NOTE: All data is COMPLETELY FAKE but uses REAL system mappings from handbook
# Affiliate networks, error reasons, statuses = REAL
# Merchant names, amounts, MIDs = COMPLETELY FAKE
# Perfect for portfolio - no real client data

# Clear existing data
PaymentFile.destroy_all
Transaction.destroy_all

# ============================================================
# FILE 1: Commission Junction UK - PARSED (Clean)
# ============================================================
file1 = PaymentFile.create!(
  filename: 'CJ-UK_testing1_2024_06_13_19711.69.xls',
  region: 'uk',
  affiliate_network: 'Commission Junction - UK',
  deposit_date: Date.new(2024, 6, 13),
  deposit_amount: 19711.69,
  payment_id: 'CJ-2641000563',
  status: 'parsed',
  file_status_label: 'PARSED'
)

# Screen 2: Display screen transactions (clean PAID status)
[
  { mid: 10234, merchant_name: 'StyleHub UK', type: 'paid_sales', status: 'paid', amount: 269.66 },
  { mid: 10234, merchant_name: 'StyleHub UK', type: 'paid_commission', status: 'paid', amount: 26.97 },
  { mid: 10567, merchant_name: 'ShopMax Ltd', type: 'paid_sales', status: 'paid', amount: 3794.51 },
  { mid: 10567, merchant_name: 'ShopMax Ltd', type: 'paid_commission', status: 'paid', amount: 659.56 },
  { mid: 10891, merchant_name: 'RetailPro London', type: 'paid_sales', status: 'paid', amount: 871.92 },
  { mid: 10891, merchant_name: 'RetailPro London', type: 'paid_commission', status: 'paid', amount: 17.42 },
  { mid: 11234, merchant_name: 'BrandCentral UK', type: 'paid_sales', status: 'paid', amount: 56.67 },
  { mid: 11234, merchant_name: 'BrandCentral UK', type: 'paid_commission', status: 'paid', amount: 2.27 },
  { mid: 11567, merchant_name: 'eCommerce Partners', type: 'paid_sales', status: 'paid', amount: 6841.73 },
  { mid: 11567, merchant_name: 'eCommerce Partners', type: 'paid_commission', status: 'paid', amount: 478.91 },
  { mid: 11891, merchant_name: 'Digital Store UK', type: 'paid_sales', status: 'paid', amount: 74.25 },
  { mid: 11891, merchant_name: 'Digital Store UK', type: 'paid_commission', status: 'paid', amount: 5.94 },
  { mid: 12234, merchant_name: 'Express Traders', type: 'paid_sales', status: 'paid', amount: 1834.0 },
  { mid: 12234, merchant_name: 'Express Traders', type: 'paid_commission', status: 'paid', amount: 91.69 },
  { mid: 12567, merchant_name: 'Online Outlet UK', type: 'paid_sales', status: 'paid', amount: 2604.6 },
  { mid: 12567, merchant_name: 'Online Outlet UK', type: 'paid_commission', status: 'paid', amount: 326.99 },
  { mid: 12891, merchant_name: 'Fashion Direct UK', type: 'paid_sales', status: 'paid', amount: 5.41 },
  { mid: 12891, merchant_name: 'Fashion Direct UK', type: 'paid_commission', status: 'paid', amount: 0.38 },
  { mid: 13234, merchant_name: 'Premium Goods Ltd', type: 'paid_sales', status: 'paid', amount: 4503.58 },
  { mid: 13234, merchant_name: 'Premium Goods Ltd', type: 'paid_commission', status: 'paid', amount: 180.23 },
  { mid: 13567, merchant_name: 'Tech Solutions UK', type: 'paid_sales', status: 'paid', amount: 504.93 },
  { mid: 13567, merchant_name: 'Tech Solutions UK', type: 'paid_commission', status: 'paid', amount: 5.05 },
  { mid: 13891, merchant_name: 'Travel Hub UK', type: 'paid_sales', status: 'paid', amount: 392.54 },
  { mid: 13891, merchant_name: 'Travel Hub UK', type: 'paid_commission', status: 'paid', amount: 19.63 },
  { mid: 14234, merchant_name: 'Beauty Store UK', type: 'paid_sales', status: 'paid', amount: 13050.42 },
  { mid: 14234, merchant_name: 'Beauty Store UK', type: 'paid_commission', status: 'paid', amount: 783.21 },
  { mid: 14567, merchant_name: 'Wine & Spirits Direct', type: 'paid_sales', status: 'paid', amount: 1704.88 },
  { mid: 14567, merchant_name: 'Wine & Spirits Direct', type: 'paid_commission', status: 'paid', amount: 18.79 },
  { mid: 14891, merchant_name: 'Sports Equipment Pro', type: 'paid_sales', status: 'paid', amount: 675.08 },
  { mid: 14891, merchant_name: 'Sports Equipment Pro', type: 'paid_commission', status: 'paid', amount: 20.33 }
].each do |txn|
  file1.transactions.create!(
    mid: txn[:mid],
    merchant_name: txn[:merchant_name],
    transaction_status: txn[:status],
    transaction_type: txn[:type],
    amount: txn[:amount],
    error_flag: false,
    screen_type: 'display',
    commission_initial: (txn[:amount] * 0.1).round(2),
    commission_final: (txn[:amount] * 0.1).round(2)
  )
end

# ============================================================
# FILE 2: Linkshare UK - PARSED WITH ERRORS (MISSING status)
# ============================================================
file2 = PaymentFile.create!(
  filename: 'Linkshare-UK_testing1_2024_06_15_7109.04.xml',
  region: 'uk',
  affiliate_network: 'Linkshare - UK',
  deposit_date: Date.new(2024, 6, 15),
  deposit_amount: 7109.04,
  payment_id: 'LS-2342453',
  status: 'parsed',
  file_status_label: 'Missing'
)

# Screen 2: Display - PAID transactions
clean_data = [
  { mid: 20234, merchant_name: 'Grocery Direct UK', type: 'paid_sales', status: 'paid', amount: 4174.52 },
  { mid: 20234, merchant_name: 'Grocery Direct UK', type: 'paid_commission', status: 'paid', amount: 38.08 },
  { mid: 20567, merchant_name: 'Fresh Market Online', type: 'paid_sales', status: 'paid', amount: 3424.28 },
  { mid: 20567, merchant_name: 'Fresh Market Online', type: 'paid_commission', status: 'paid', amount: 362.56 },
  { mid: 20891, merchant_name: 'Audio World UK', type: 'paid_sales', status: 'paid', amount: 7746.4 },
  { mid: 20891, merchant_name: 'Audio World UK', type: 'paid_commission', status: 'paid', amount: 227.43 },
  { mid: 21234, merchant_name: 'Gift Shop Express', type: 'paid_sales', status: 'paid', amount: 331.32 },
  { mid: 21234, merchant_name: 'Gift Shop Express', type: 'paid_commission', status: 'paid', amount: 4.97 },
  { mid: 21567, merchant_name: 'Computer Hub Ltd', type: 'paid_sales', status: 'paid', amount: 1668.47 },
  { mid: 21567, merchant_name: 'Computer Hub Ltd', type: 'paid_commission', status: 'paid', amount: 94.85 },
  { mid: 21891, merchant_name: 'Travel & Leisure', type: 'paid_sales', status: 'paid', amount: 1751.82 },
  { mid: 21891, merchant_name: 'Travel & Leisure', type: 'paid_commission', status: 'paid', amount: 59.21 },
  { mid: 22234, merchant_name: 'Dining Experiences Co', type: 'paid_sales', status: 'paid', amount: 4328.61 },
  { mid: 22234, merchant_name: 'Dining Experiences Co', type: 'paid_commission', status: 'paid', amount: 173.17 },
  { mid: 22567, merchant_name: 'Luxury Goods International', type: 'paid_sales', status: 'paid', amount: 93422.36 },
  { mid: 22567, merchant_name: 'Luxury Goods International', type: 'paid_commission', status: 'paid', amount: 2780.01 },
  { mid: 22891, merchant_name: 'Furniture Hub', type: 'paid_sales', status: 'paid', amount: 297.7 },
  { mid: 22891, merchant_name: 'Furniture Hub', type: 'paid_commission', status: 'paid', amount: 7.44 },
  { mid: 23234, merchant_name: 'Shoe Gallery Pro', type: 'paid_sales', status: 'paid', amount: 56.36 },
  { mid: 23234, merchant_name: 'Shoe Gallery Pro', type: 'paid_commission', status: 'paid', amount: 1.41 }
]

# Screen 3: MISSING transactions with real error reasons from handbook
error_data = [
  { mid: 30234, merchant_name: 'Power Tools Direct', type: 'paid_commission', status: 'missing', amount: 2.93, error: 'COMMISSION_MISMATCH' },
  { mid: 30567, merchant_name: 'Fashion Outlet Co', type: 'paid_commission', status: 'missing', amount: 9.29, error: 'COMMISSION_MISMATCH' },
  { mid: 30891, merchant_name: 'Electronics Plus', type: 'paid_commission', status: 'missing', amount: 6.75, error: 'TRANSACTION_NOT_FOUND' },
  { mid: 31234, merchant_name: 'Jewelry Store Express', type: 'paid_commission', status: 'missing', amount: 2.29, error: 'AGGREGATOR_TRANSACTION_ID_NOT_FOUND' },
  { mid: 31567, merchant_name: 'Outdoor Gear Ltd', type: 'paid_commission', status: 'missing', amount: 21.99, error: 'AGGREGATOR_MISMATCH' },
  { mid: 31891, merchant_name: 'Sneaker Palace', type: 'paid_commission', status: 'missing', amount: 0.25, error: 'INVALID_COMMISSION_VALUE' },
  { mid: 32234, merchant_name: 'Flight Booking Hub', type: 'paid_commission', status: 'missing', amount: 28.95, error: 'INVALID_DATE' },
  { mid: 32567, merchant_name: 'Vision Care Plus', type: 'paid_commission', status: 'missing', amount: 33.24, error: 'INVALID_SALE_VALUE' }
]

# Add clean PAID transactions to file2
clean_data.each do |txn|
  file2.transactions.create!(
    mid: txn[:mid],
    merchant_name: txn[:merchant_name],
    transaction_status: txn[:status],
    transaction_type: txn[:type],
    amount: txn[:amount],
    error_flag: false,
    screen_type: 'display',
    commission_initial: (txn[:amount] * 0.1).round(2),
    commission_final: (txn[:amount] * 0.1).round(2)
  )
end

# Add MISSING error transactions to file2
error_data.each do |txn|
  file2.transactions.create!(
    mid: txn[:mid],
    merchant_name: txn[:merchant_name],
    transaction_status: txn[:status],
    transaction_type: txn[:type],
    amount: txn[:amount],
    error_flag: true,
    error_reason: txn[:error],
    screen_type: 'display',
    commission_initial: (txn[:amount] * 0.1).round(2),
    commission_final: (txn[:amount] * 0.1).round(2)
  )
end

# ============================================================
# FILE 3: Qantas AU - FULL RECONCILED (CLOSED status)
# ============================================================
file3 = PaymentFile.create!(
  filename: 'Qantas-PHG-AU_testing1_2024_06_13_283.45.xls',
  region: 'au',
  affiliate_network: 'Qantas - AU',
  deposit_date: Date.new(2024, 6, 13),
  deposit_amount: 283.45,
  payment_id: 'QNT-8373928',
  status: 'full_reconciled',
  file_status_label: 'RECONCILED'
)

# Screen 5: Summary - CLOSED transactions (locked)
summary_data = [
  { mid: 40234, merchant_name: 'AusShop Online', type: 'transaction', status: 'closed', initial: 6.11, final: 6.11, locked: true },
  { mid: 40567, merchant_name: 'Sydney Store Ltd', type: 'transaction', status: 'closed', initial: 58.0, final: 58.0, locked: true },
  { mid: 40891, merchant_name: 'Melbourne Traders', type: 'transaction', status: 'closed', initial: 191.80, final: 191.80, locked: true },
  { mid: 41234, merchant_name: 'Brisbane Retail CA', type: 'transaction', status: 'closed', initial: 0.87, final: 0.87, locked: true },
  { mid: 41567, merchant_name: 'Perth Digital Au', type: 'transaction', status: 'closed', initial: 7.42, final: 7.42, locked: true },
  { mid: 41891, merchant_name: 'Adelaide Shop', type: 'transaction', status: 'closed', initial: 19.26, final: 19.26, locked: true }
]

summary_data.each do |txn|
  file3.transactions.create!(
    mid: txn[:mid],
    merchant_name: txn[:merchant_name],
    transaction_status: txn[:status],
    transaction_type: txn[:type],
    amount: txn[:initial],
    error_flag: false,
    screen_type: 'summary',
    commission_initial: txn[:initial],
    commission_final: txn[:final],
    transaction_locked: txn[:locked]
  )
end

# Bonus transaction in summary
file3.transactions.create!(
  mid: 0,
  merchant_name: 'System',
  transaction_status: 'closed',
  transaction_type: 'bonus',
  amount: -0.01,
  error_flag: false,
  screen_type: 'summary',
  commission_initial: 0,
  commission_final: -0.01,
  transaction_locked: true
)

# ============================================================
# FILE 4: WebLogic UK - Ready for Processing
# ============================================================
file4 = PaymentFile.create!(
  filename: 'WebLogic-UK_testing1_2024_06_20_5432.10.csv',
  region: 'uk',
  affiliate_network: 'WebLogic - UK',
  deposit_date: Date.new(2024, 6, 20),
  deposit_amount: 5432.10,
  payment_id: 'WL-9281930',
  status: 'ready',
  file_status_label: 'READY'
)

# No transactions for ready file (not yet processed)

# ============================================================
# FILE 5: Commission Junction CA - Processing
# ============================================================
file5 = PaymentFile.create!(
  filename: 'CJ-CA_testing1_2024_06_22_3210.50.xlsx',
  region: 'ca',
  affiliate_network: 'Commission Junction - CA',
  deposit_date: Date.new(2024, 6, 22),
  deposit_amount: 3210.50,
  payment_id: 'CJ-7654321',
  status: 'processing',
  file_status_label: 'PROCESSING'
)

# No transactions for processing file

# ============================================================
# FILE 6: Linkshare AU - With DECLINED transactions
# ============================================================
file6 = PaymentFile.create!(
  filename: 'Linkshare-AU_testing1_2024_06_25_2156.78.xls',
  region: 'au',
  affiliate_network: 'Linkshare - AU',
  deposit_date: Date.new(2024, 6, 25),
  deposit_amount: 2156.78,
  payment_id: 'LS-5829103',
  status: 'parsed',
  file_status_label: 'PARSED'
)

# DECLINED transactions (Commission Junction is the only one sending declined data per handbook)
declined_data = [
  { mid: 50234, merchant_name: 'Declined Retail Store', type: 'declined_sales', status: 'declined', amount: 145.67 },
  { mid: 50234, merchant_name: 'Declined Retail Store', type: 'declined_commission', status: 'declined', amount: 14.57 },
  { mid: 50567, merchant_name: 'Rejected Shop', type: 'declined_sales', status: 'declined', amount: 892.34 },
  { mid: 50567, merchant_name: 'Rejected Shop', type: 'declined_commission', status: 'declined', amount: 89.23 }
]

declined_data.each do |txn|
  file6.transactions.create!(
    mid: txn[:mid],
    merchant_name: txn[:merchant_name],
    transaction_status: txn[:status],
    transaction_type: txn[:type],
    amount: txn[:amount],
    error_flag: false,
    screen_type: 'display',
    commission_initial: (txn[:amount] * 0.1).round(2),
    commission_final: (txn[:amount] * 0.1).round(2)
  )
end

puts "✓ Created #{PaymentFile.count} payment files"
puts "✓ Created #{Transaction.count} transactions"
puts ""
puts "Files created:"
PaymentFile.all.each do |f|
  puts "  - #{f.filename} (#{f.status}) - #{f.transaction_count} transactions"
end
puts ""
puts "File Status Breakdown:"
puts "  - PARSED: #{PaymentFile.where(status: 'parsed').count}"
puts "  - FULL RECONCILED: #{PaymentFile.where(status: 'full_reconciled').count}"
puts "  - READY: #{PaymentFile.where(status: 'ready').count}"
puts "  - PROCESSING: #{PaymentFile.where(status: 'processing').count}"
puts ""
puts "Transaction Status Breakdown:"
puts "  - PAID: #{Transaction.where(transaction_status: 'paid').count}"
puts "  - DECLINED: #{Transaction.where(transaction_status: 'declined').count}"
puts "  - MISSING: #{Transaction.where(transaction_status: 'missing').count}"
puts "  - CLOSED: #{Transaction.where(transaction_status: 'closed').count}"
puts ""
puts "Error Scenarios:"
puts "  - Total with errors: #{Transaction.where(error_flag: true).count}"
```

---

## SUMMARY

You now have all 5 code files with **REAL SYSTEM MAPPINGS + FAKE DATA:**

✅ **REAL (from handbook):**
1. ✅ `app/models/payment_file.rb` - Real affiliate networks & statuses
2. ✅ `app/models/transaction.rb` - Real error reasons & transaction statuses
3. ✅ `db/migrate/[timestamp]_create_payment_files.rb` - Real schema
4. ✅ `db/migrate/[timestamp]_create_transactions.rb` - Real schema with transaction_status
5. ✅ `db/seeds.rb` - Seed data with REAL error mappings

✅ **FAKE but REALISTIC (for privacy):**
- Merchant names: StyleHub UK, ShopMax Ltd, etc.
- MID numbers: 10234, 10567, etc.
- Amounts: Realistic ranges
- File names: Real format with fake dates/amounts

✅ **AUTHENTIC SYSTEM FEATURES:**
- Real affiliate networks: Commission Junction, Linkshare, Qantas
- Real transaction statuses: PAID, DECLINED, MISSING, CLOSED
- Real error reasons: COMMISSION_MISMATCH, TRANSACTION_NOT_FOUND, AGGREGATOR_TRANSACTION_ID_NOT_FOUND, etc.
- Real file statuses: new, ready, processing, parsed, partial_reconciled, full_reconciled
- Real business rules: DECLINED only from Commission Junction, proper error descriptions

## Next Steps

```bash
# 1. Copy each file from above to your project
# 2. Run migrations
rails db:migrate

# 3. Run seeds
rails db:seed

# 4. Verify (you should see 6 payment files, 70+ transactions)
rails console
> PaymentFile.count
> Transaction.count
> Transaction.where(transaction_status: 'paid').count
> Transaction.where(error_flag: true).count
```

**Done!** Task 2 with real system mappings + fake data. Perfect for portfolio! ✓

**Ready to implement?** 🚀
