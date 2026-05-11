# Task 2 - ALL CODE FILES (Copy-Paste Ready)

## How to Use This Document

1. Copy the code from each section below
2. Create the file in your project with the exact path shown
3. Paste the code
4. Save the file
5. Move to next file

---

## FILE 1: app/models/payment_file.rb

**Create file:** `app/models/payment_file.rb`

```ruby
class PaymentFile < ApplicationRecord
  has_many :transactions, dependent: :destroy

  # Enums
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
    us: 'us'
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

  # Constants
  AFFILIATE_NETWORKS = [
    'Commission Junction - UK',
    'Linkshare - UK',
    'Awin - UK',
    'TradeTracker - UK',
    'CPA Lead',
    'Commission Junction - CA',
    'Linkshare - CA',
    'Awin - CA'
  ].freeze

  REGIONS_DISPLAY = {
    'uk' => 'UK',
    'ca' => 'CA',
    'us' => 'US'
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

  # Enums
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

  # Constants
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

  ERROR_REASONS = {
    'MAPPING_ERROR' => 'Mapping Error - Payment ID Not Found',
    'AMOUNT_MISMATCH' => 'Amount Mismatch',
    'MISSING_TRANSACTION' => 'Missing Transaction',
    'DISCREPANCY' => 'Amount Discrepancy'
  }.freeze

  # Instance methods
  def type_display
    TRANSACTION_TYPE_DISPLAY[transaction_type]
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

(Replace [timestamp] with current timestamp, e.g., 20250511120000)

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
    add_index :transactions, :mid
  end
end
```

---

## FILE 5: db/seeds.rb

**Replace file:** `db/seeds.rb`

(Delete existing content and replace with this)

```ruby
# db/seeds.rb
# Seed data for Payment Reconciliation Portfolio App

# Clear existing data
PaymentFile.destroy_all
Transaction.destroy_all

# Merchant data (denormalized into transactions)
MERCHANTS = {
  35838 => 'Ancestry UK',
  8980 => 'ASOS',
  17227 => 'Aveda',
  55380 => 'Bonmarche',
  51227 => 'Buyagift',
  26910 => 'Cabin Zero',
  47568 => 'Childsplay Clothing',
  46998 => 'Cutter and Squidge',
  24416 => 'e.l.f. Cosmetics',
  22126 => 'Estee Lauder',
  29777 => 'Face the Future',
  17056 => 'Gatwick Holiday Parking',
  25770 => 'H&M',
  15231 => 'Laithwaites',
  14249 => 'Mainline',
  36334 => 'Office Shoes',
  18020 => 'Oliver Bonas',
  51226 => 'Red Letter Days',
  50614 => 'Samsung',
  29247 => 'Temple Spa',
  35985 => 'The Perfume Shop',
  37538 => 'Threadbare',
  28942 => 'Tory Burch',
  25099 => 'Urban Outfitters',
  32485 => 'Weekday',
  37015 => 'ASDA Groceries',
  32704 => 'ASOS Groceries',
  15950 => 'Bose',
  27883 => 'BrandAlley',
  24887 => 'Dell Refurbished'
}.freeze

# ============================================================
# FILE 1: Commission Junction UK - PARSED (Clean)
# ============================================================
file1 = PaymentFile.create!(
  filename: 'CJ-UK_2026_02_18_19711.69.xlsx',
  region: 'uk',
  affiliate_network: 'Commission Junction - UK',
  deposit_date: Date.new(2026, 2, 18),
  deposit_amount: 19711.69,
  payment_id: '2641000563',
  status: 'parsed',
  file_status_label: 'PARSED'
)

# Screen 2: Display screen transactions (clean data)
[
  { mid: 35838, merchant_name: 'Ancestry UK', type: 'paid_sales', amount: 269.66 },
  { mid: 35838, merchant_name: 'Ancestry UK', type: 'paid_commission', amount: 26.97 },
  { mid: 8980, merchant_name: 'ASOS', type: 'paid_sales', amount: 3794.51 },
  { mid: 8980, merchant_name: 'ASOS', type: 'paid_commission', amount: 659.56 },
  { mid: 17227, merchant_name: 'Aveda', type: 'paid_sales', amount: 871.92 },
  { mid: 17227, merchant_name: 'Aveda', type: 'paid_commission', amount: 17.42 },
  { mid: 55380, merchant_name: 'Bonmarche', type: 'paid_sales', amount: 56.67 },
  { mid: 55380, merchant_name: 'Bonmarche', type: 'paid_commission', amount: 2.27 },
  { mid: 51227, merchant_name: 'Buyagift', type: 'paid_sales', amount: 6841.73 },
  { mid: 51227, merchant_name: 'Buyagift', type: 'paid_commission', amount: 478.91 },
  { mid: 26910, merchant_name: 'Cabin Zero', type: 'paid_sales', amount: 74.25 },
  { mid: 26910, merchant_name: 'Cabin Zero', type: 'paid_commission', amount: 5.94 },
  { mid: 47568, merchant_name: 'Childsplay Clothing', type: 'paid_sales', amount: 1834.0 },
  { mid: 47568, merchant_name: 'Childsplay Clothing', type: 'paid_commission', amount: 91.69 },
  { mid: 46998, merchant_name: 'Cutter and Squidge', type: 'paid_sales', amount: 2604.6 },
  { mid: 46998, merchant_name: 'Cutter and Squidge', type: 'paid_commission', amount: 326.99 },
  { mid: 24416, merchant_name: 'e.l.f. Cosmetics', type: 'paid_sales', amount: 5.41 },
  { mid: 24416, merchant_name: 'e.l.f. Cosmetics', type: 'paid_commission', amount: 0.38 },
  { mid: 22126, merchant_name: 'Estee Lauder', type: 'paid_sales', amount: 4503.58 },
  { mid: 22126, merchant_name: 'Estee Lauder', type: 'paid_commission', amount: 180.23 },
  { mid: 29777, merchant_name: 'Face the Future', type: 'paid_sales', amount: 504.93 },
  { mid: 29777, merchant_name: 'Face the Future', type: 'paid_commission', amount: 5.05 },
  { mid: 17056, merchant_name: 'Gatwick Holiday Parking', type: 'paid_sales', amount: 392.54 },
  { mid: 17056, merchant_name: 'Gatwick Holiday Parking', type: 'paid_commission', amount: 19.63 },
  { mid: 25770, merchant_name: 'H&M', type: 'paid_sales', amount: 13050.42 },
  { mid: 25770, merchant_name: 'H&M', type: 'paid_commission', amount: 783.21 },
  { mid: 15231, merchant_name: 'Laithwaites', type: 'paid_sales', amount: 1704.88 },
  { mid: 15231, merchant_name: 'Laithwaites', type: 'paid_commission', amount: 18.79 },
  { mid: 14249, merchant_name: 'Mainline', type: 'paid_sales', amount: 675.08 },
  { mid: 14249, merchant_name: 'Mainline', type: 'paid_commission', amount: 20.33 }
].each do |txn|
  file1.transactions.create!(
    mid: txn[:mid],
    merchant_name: txn[:merchant_name],
    transaction_type: txn[:type],
    amount: txn[:amount],
    error_flag: false,
    screen_type: 'display',
    commission_initial: (txn[:amount] * 0.1).round(2),
    commission_final: (txn[:amount] * 0.1).round(2)
  )
end

# ============================================================
# FILE 2: Linkshare UK - PARSED WITH ERRORS
# ============================================================
file2 = PaymentFile.create!(
  filename: 'Linkshare-UK_2026_03_11_7109.04.xml',
  region: 'uk',
  affiliate_network: 'Linkshare - UK',
  deposit_date: Date.new(2026, 3, 11),
  deposit_amount: 7109.04,
  payment_id: '2342453',
  status: 'parsed',
  file_status_label: 'Missing'
)

# Screen 2 & 3: Mix of clean and error transactions
clean_data = [
  { mid: 37015, merchant_name: 'ASDA Groceries', type: 'paid_sales', amount: 4174.52 },
  { mid: 37015, merchant_name: 'ASDA Groceries', type: 'paid_commission', amount: 38.08 },
  { mid: 32704, merchant_name: 'ASOS Groceries', type: 'paid_sales', amount: 3424.28 },
  { mid: 32704, merchant_name: 'ASOS Groceries', type: 'paid_commission', amount: 3625.62 },
  { mid: 15950, merchant_name: 'Bose', type: 'paid_sales', amount: 7746.4 },
  { mid: 15950, merchant_name: 'Bose', type: 'paid_commission', amount: 227.43 },
  { mid: 27883, merchant_name: 'BrandAlley', type: 'paid_sales', amount: 331.32 },
  { mid: 27883, merchant_name: 'BrandAlley', type: 'paid_commission', amount: 4.97 },
  { mid: 24887, merchant_name: 'Dell Refurbished', type: 'paid_sales', amount: 1668.47 },
  { mid: 24887, merchant_name: 'Dell Refurbished', type: 'paid_commission', amount: 94.85 },
  { mid: 47150, merchant_name: 'Direct Ferries', type: 'paid_sales', amount: 1751.82 },
  { mid: 47150, merchant_name: 'Direct Ferries', type: 'paid_commission', amount: 59.21 },
  { mid: 23135, merchant_name: 'DinersGlobe', type: 'paid_sales', amount: 4328.61 },
  { mid: 23135, merchant_name: 'DinersGlobe', type: 'paid_commission', amount: 173.17 },
  { mid: 4016, merchant_name: 'Emirates', type: 'paid_sales', amount: 93422.36 },
  { mid: 4016, merchant_name: 'Emirates', type: 'paid_commission', amount: 2780.01 },
  { mid: 26792, merchant_name: 'Fernell', type: 'paid_sales', amount: 297.7 },
  { mid: 26792, merchant_name: 'Fernell', type: 'paid_commission', amount: 7.44 },
  { mid: 36676, merchant_name: 'Footshop', type: 'paid_sales', amount: 56.36 },
  { mid: 36676, merchant_name: 'Footshop', type: 'paid_commission', amount: 1.41 }
]

error_data = [
  { mid: 30745, merchant_name: 'Karcher', type: 'paid_commission', amount: 2.93, error: 'AMOUNT_MISMATCH' },
  { mid: 34601, merchant_name: 'Lands\' End UK', type: 'paid_commission', amount: 9.29, error: 'AMOUNT_MISMATCH' },
  { mid: 26004, merchant_name: 'RS Components', type: 'paid_commission', amount: 6.75, error: 'AMOUNT_MISMATCH' },
  { mid: 28443, merchant_name: 'Sunglasshut', type: 'paid_commission', amount: 2.29, error: 'MISSING_TRANSACTION' },
  { mid: 21541, merchant_name: 'The North Face', type: 'paid_commission', amount: 21.99, error: 'AMOUNT_MISMATCH' },
  { mid: 22336, merchant_name: 'Vans', type: 'paid_commission', amount: 0.25, error: 'DISCREPANCY' },
  { mid: 26086, merchant_name: 'Virgin Atlantic Airways', type: 'paid_commission', amount: 28.95, error: 'AMOUNT_MISMATCH' },
  { mid: 38666, merchant_name: 'Vision Express', type: 'paid_commission', amount: 33.24, error: 'AMOUNT_MISMATCH' }
]

# Add clean transactions to file2
clean_data.each do |txn|
  file2.transactions.create!(
    mid: txn[:mid],
    merchant_name: txn[:merchant_name],
    transaction_type: txn[:type],
    amount: txn[:amount],
    error_flag: false,
    screen_type: 'display',
    commission_initial: (txn[:amount] * 0.1).round(2),
    commission_final: (txn[:amount] * 0.1).round(2)
  )
end

# Add error transactions to file2 (marked with error_flag: true)
error_data.each do |txn|
  file2.transactions.create!(
    mid: txn[:mid],
    merchant_name: txn[:merchant_name],
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
# FILE 3: Commission Junction CA - FULL RECONCILED
# ============================================================
file3 = PaymentFile.create!(
  filename: 'CJ-CA_2026_03_16_283.45.xlsx',
  region: 'ca',
  affiliate_network: 'Commission Junction - CA',
  deposit_date: Date.new(2026, 3, 16),
  deposit_amount: 283.45,
  payment_id: '8373928',
  status: 'full_reconciled',
  file_status_label: 'FULL RECONCILED'
)

# Screen 5: Summary data with locked transactions
summary_data = [
  { mid: 25463, merchant_name: '123Ink.ca', type: 'transaction', initial: 6.11, final: 6.11, locked: true },
  { mid: 28278, merchant_name: 'Columbia Sportswear Canada', type: 'transaction', initial: 58.0, final: 58.0, locked: true },
  { mid: 27673, merchant_name: 'Expedia Canada', type: 'transaction', initial: 191.80, final: 191.80, locked: true },
  { mid: 28792, merchant_name: 'Hotels.com', type: 'transaction', initial: 0.87, final: 0.87, locked: true },
  { mid: 55210, merchant_name: 'Sony', type: 'transaction', initial: 7.42, final: 7.42, locked: true },
  { mid: 47130, merchant_name: 'Temu Canada', type: 'transaction', initial: 19.26, final: 19.26, locked: true }
]

summary_data.each do |txn|
  file3.transactions.create!(
    mid: txn[:mid],
    merchant_name: txn[:merchant_name],
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
  transaction_type: 'bonus',
  amount: -0.01,
  error_flag: false,
  screen_type: 'summary',
  commission_initial: 0,
  commission_final: -0.01,
  transaction_locked: true
)

# ============================================================
# FILE 4: Ready for Processing
# ============================================================
file4 = PaymentFile.create!(
  filename: 'Fresh_Upload_2026_03_20_5432.10.csv',
  region: 'uk',
  affiliate_network: 'Awin - UK',
  deposit_date: Date.new(2026, 3, 20),
  deposit_amount: 5432.10,
  payment_id: '9281930',
  status: 'ready',
  file_status_label: 'READY'
)

# No transactions for ready file (not yet processed)

# ============================================================
# FILE 5: Processing
# ============================================================
file5 = PaymentFile.create!(
  filename: 'In_Progress_2026_03_22.xlsx',
  region: 'ca',
  affiliate_network: 'Linkshare - CA',
  deposit_date: Date.new(2026, 3, 22),
  deposit_amount: 3210.50,
  payment_id: '7654321',
  status: 'processing',
  file_status_label: 'PROCESSING'
)

# No transactions for processing file

puts "✓ Created #{PaymentFile.count} payment files"
puts "✓ Created #{Transaction.count} transactions"
puts ""
puts "Files created:"
PaymentFile.all.each do |f|
  puts "  - #{f.filename} (#{f.status}) - #{f.transaction_count} transactions"
end
```

---

## SUMMARY

You now have all 5 code files:

1. ✅ `app/models/payment_file.rb` - Payment file model
2. ✅ `app/models/transaction.rb` - Transaction model
3. ✅ `db/migrate/[timestamp]_create_payment_files.rb` - Payment files migration
4. ✅ `db/migrate/[timestamp]_create_transactions.rb` - Transactions migration
5. ✅ `db/seeds.rb` - Seed data (5 files, 70 transactions)

## Next Steps

```bash
# 1. Copy each file from above to your project
# 2. Run migrations
rails db:migrate

# 3. Run seeds
rails db:seed

# 4. Verify
rails console
> PaymentFile.count  # Should be 5
> Transaction.count  # Should be 70
```

**Done!** Task 2 is complete. ✓
