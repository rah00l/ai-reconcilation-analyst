# db/seeds.rb - v0.6.2 DATA CLEANUP
# Seed data for Payment Reconciliation Portfolio App
# NOTE: All data is COMPLETELY FAKE - both names and mappings
# This is for portfolio demonstration only - no real client data
# Affiliate networks, merchant names, payment IDs, file names = ALL FAKE/SYNTHETIC

# Clear existing data
PaymentFile.destroy_all
Transaction.destroy_all

# ============================================================
# SYNTHETIC AFFILIATE NETWORKS (NOT real networks)
# ============================================================
# Changed from: Commission Junction, Linkshare, Qantas, WebLogic
# To: Completely fictional names for portfolio
# This prevents any confusion with actual affiliate networks

# ============================================================
# FILE 1: DynamoPartner EU - PARSED (Clean)
# ============================================================
file1 = PaymentFile.create!(
  filename: 'DYNPART_EU_demo_2024_06_13_19711.69.xls',
  region: 'uk',
  affiliate_network: 'DynamoPartner EU',
  deposit_date: Date.new(2024, 6, 13),
  deposit_amount: 19711.69,
  payment_id: 'DP-EU-0001-2024Q2',
  status: 'parsed',
  file_status_label: 'PARSED'
)

# Screen 2: Display screen transactions (clean PAID status)
[
  { mid: 10234, merchant_name: 'Acme Electronics Store', type: 'paid_sales', status: 'paid', amount: 269.66 },
  { mid: 10234, merchant_name: 'Acme Electronics Store', type: 'paid_commission', status: 'paid', amount: 26.97 },
  { mid: 10567, merchant_name: 'Nexus Retail Solutions', type: 'paid_sales', status: 'paid', amount: 3794.51 },
  { mid: 10567, merchant_name: 'Nexus Retail Solutions', type: 'paid_commission', status: 'paid', amount: 659.56 },
  { mid: 10891, merchant_name: 'Prism Digital Ltd', type: 'paid_sales', status: 'paid', amount: 871.92 },
  { mid: 10891, merchant_name: 'Prism Digital Ltd', type: 'paid_commission', status: 'paid', amount: 17.42 },
  { mid: 11234, merchant_name: 'Zenith Commerce', type: 'paid_sales', status: 'paid', amount: 56.67 },
  { mid: 11234, merchant_name: 'Zenith Commerce', type: 'paid_commission', status: 'paid', amount: 2.27 },
  { mid: 11567, merchant_name: 'Velocity Trade Hub', type: 'paid_sales', status: 'paid', amount: 6841.73 },
  { mid: 11567, merchant_name: 'Velocity Trade Hub', type: 'paid_commission', status: 'paid', amount: 478.91 },
  { mid: 11891, merchant_name: 'Aurora Online Store', type: 'paid_sales', status: 'paid', amount: 74.25 },
  { mid: 11891, merchant_name: 'Aurora Online Store', type: 'paid_commission', status: 'paid', amount: 5.94 },
  { mid: 12234, merchant_name: 'Catalyst Merchants', type: 'paid_sales', status: 'paid', amount: 1834.0 },
  { mid: 12234, merchant_name: 'Catalyst Merchants', type: 'paid_commission', status: 'paid', amount: 91.69 },
  { mid: 12567, merchant_name: 'Quantum Market Place', type: 'paid_sales', status: 'paid', amount: 2604.6 },
  { mid: 12567, merchant_name: 'Quantum Market Place', type: 'paid_commission', status: 'paid', amount: 326.99 },
  { mid: 12891, merchant_name: 'Apex Fashion Co', type: 'paid_sales', status: 'paid', amount: 5.41 },
  { mid: 12891, merchant_name: 'Apex Fashion Co', type: 'paid_commission', status: 'paid', amount: 0.38 },
  { mid: 13234, merchant_name: 'Spectrum Goods International', type: 'paid_sales', status: 'paid', amount: 4503.58 },
  { mid: 13234, merchant_name: 'Spectrum Goods International', type: 'paid_commission', status: 'paid', amount: 180.23 },
  { mid: 13567, merchant_name: 'Vertex Tech Solutions', type: 'paid_sales', status: 'paid', amount: 504.93 },
  { mid: 13567, merchant_name: 'Vertex Tech Solutions', type: 'paid_commission', status: 'paid', amount: 5.05 },
  { mid: 13891, merchant_name: 'Nova Journey Co', type: 'paid_sales', status: 'paid', amount: 392.54 },
  { mid: 13891, merchant_name: 'Nova Journey Co', type: 'paid_commission', status: 'paid', amount: 19.63 },
  { mid: 14234, merchant_name: 'Radiance Beauty Marketplace', type: 'paid_sales', status: 'paid', amount: 13050.42 },
  { mid: 14234, merchant_name: 'Radiance Beauty Marketplace', type: 'paid_commission', status: 'paid', amount: 783.21 },
  { mid: 14567, merchant_name: 'Horizon Beverages Ltd', type: 'paid_sales', status: 'paid', amount: 1704.88 },
  { mid: 14567, merchant_name: 'Horizon Beverages Ltd', type: 'paid_commission', status: 'paid', amount: 18.79 },
  { mid: 14891, merchant_name: 'Pinnacle Sports Gear', type: 'paid_sales', status: 'paid', amount: 675.08 },
  { mid: 14891, merchant_name: 'Pinnacle Sports Gear', type: 'paid_commission', status: 'paid', amount: 20.33 }
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
# FILE 2: CloudBridge Network - PARSED WITH ERRORS (MISSING status)
# ============================================================
file2 = PaymentFile.create!(
  filename: 'CLDBRG_ASIA_demo_2024_06_15_7109.04.xml',
  region: 'uk',
  affiliate_network: 'CloudBridge Network',
  deposit_date: Date.new(2024, 6, 15),
  deposit_amount: 7109.04,
  payment_id: 'CB-ASIA-0002-2024Q2',
  status: 'parsed',
  file_status_label: 'Missing'
)

# Screen 2: Display - PAID transactions
clean_data = [
  { mid: 20234, merchant_name: 'Atlas Supply Chain', type: 'paid_sales', status: 'paid', amount: 4174.52 },
  { mid: 20234, merchant_name: 'Atlas Supply Chain', type: 'paid_commission', status: 'paid', amount: 38.08 },
  { mid: 20567, merchant_name: 'Orion Market Traders', type: 'paid_sales', status: 'paid', amount: 3424.28 },
  { mid: 20567, merchant_name: 'Orion Market Traders', type: 'paid_commission', status: 'paid', amount: 362.56 },
  { mid: 20891, merchant_name: 'Helix Sound Systems', type: 'paid_sales', status: 'paid', amount: 7746.4 },
  { mid: 20891, merchant_name: 'Helix Sound Systems', type: 'paid_commission', status: 'paid', amount: 227.43 },
  { mid: 21234, merchant_name: 'Eclipse Gift Emporium', type: 'paid_sales', status: 'paid', amount: 331.32 },
  { mid: 21234, merchant_name: 'Eclipse Gift Emporium', type: 'paid_commission', status: 'paid', amount: 4.97 },
  { mid: 21567, merchant_name: 'Fusion Computing Hub', type: 'paid_sales', status: 'paid', amount: 1668.47 },
  { mid: 21567, merchant_name: 'Fusion Computing Hub', type: 'paid_commission', status: 'paid', amount: 94.85 },
  { mid: 21891, merchant_name: 'Meridian Leisure Group', type: 'paid_sales', status: 'paid', amount: 1751.82 },
  { mid: 21891, merchant_name: 'Meridian Leisure Group', type: 'paid_commission', status: 'paid', amount: 59.21 },
  { mid: 22234, merchant_name: 'Titan Dining Concepts', type: 'paid_sales', status: 'paid', amount: 4328.61 },
  { mid: 22234, merchant_name: 'Titan Dining Concepts', type: 'paid_commission', status: 'paid', amount: 173.17 },
  { mid: 22567, merchant_name: 'Luxe Global Holdings', type: 'paid_sales', status: 'paid', amount: 93422.36 },
  { mid: 22567, merchant_name: 'Luxe Global Holdings', type: 'paid_commission', status: 'paid', amount: 2780.01 },
  { mid: 22891, merchant_name: 'Vertex Interior Design', type: 'paid_sales', status: 'paid', amount: 297.7 },
  { mid: 22891, merchant_name: 'Vertex Interior Design', type: 'paid_commission', status: 'paid', amount: 7.44 },
  { mid: 23234, merchant_name: 'Genesis Footwear Plus', type: 'paid_sales', status: 'paid', amount: 56.36 },
  { mid: 23234, merchant_name: 'Genesis Footwear Plus', type: 'paid_commission', status: 'paid', amount: 1.41 }
]

# Screen 3: MISSING transactions with real error reasons from handbook
error_data = [
  { mid: 30234, merchant_name: 'Titan Industrial Tools', type: 'paid_commission', status: 'missing', amount: 2.93, error: 'COMMISSION_MISMATCH' },
  { mid: 30567, merchant_name: 'Phoenix Fashion Hub', type: 'paid_commission', status: 'missing', amount: 9.29, error: 'COMMISSION_MISMATCH' },
  { mid: 30891, merchant_name: 'Nexus Tech Distributors', type: 'paid_commission', status: 'missing', amount: 6.75, error: 'TRANSACTION_NOT_FOUND' },
  { mid: 31234, merchant_name: 'Crown Jewelry Store', type: 'paid_commission', status: 'missing', amount: 2.29, error: 'AGGREGATOR_TRANSACTION_ID_NOT_FOUND' },
  { mid: 31567, merchant_name: 'Zenith Outdoor Ventures', type: 'paid_commission', status: 'missing', amount: 21.99, error: 'AGGREGATOR_MISMATCH' },
  { mid: 31891, merchant_name: 'Velocity Athletic Wear', type: 'paid_commission', status: 'missing', amount: 0.25, error: 'INVALID_COMMISSION_VALUE' },
  { mid: 32234, merchant_name: 'Horizon Travel Bookings', type: 'paid_commission', status: 'missing', amount: 28.95, error: 'INVALID_DATE' },
  { mid: 32567, merchant_name: 'Prism Vision Services', type: 'paid_commission', status: 'missing', amount: 33.24, error: 'INVALID_SALE_VALUE' }
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
# FILE 3: StellarConnect APAC - FULL RECONCILED (CLOSED status)
# ============================================================
file3 = PaymentFile.create!(
  filename: 'STELLAR_APAC_demo_2024_06_13_283.45.xls',
  region: 'au',
  affiliate_network: 'StellarConnect APAC',
  deposit_date: Date.new(2024, 6, 13),
  deposit_amount: 283.45,
  payment_id: 'SC-APAC-0003-2024Q2',
  status: 'full_reconciled',
  file_status_label: 'RECONCILED'
)

# Screen 5: Summary - CLOSED transactions (locked)
summary_data = [
  { mid: 40234, merchant_name: 'Infinity Online Retail', type: 'transaction', status: 'closed', initial: 6.11, final: 6.11, locked: true },
  { mid: 40567, merchant_name: 'Aurora Digital Store', type: 'transaction', status: 'closed', initial: 58.0, final: 58.0, locked: true },
  { mid: 40891, merchant_name: 'Horizon Commerce Group', type: 'transaction', status: 'closed', initial: 191.80, final: 191.80, locked: true },
  { mid: 41234, merchant_name: 'Nexus Regional Sales', type: 'transaction', status: 'closed', initial: 0.87, final: 0.87, locked: true },
  { mid: 41567, merchant_name: 'Vertex Pacific Trading', type: 'transaction', status: 'closed', initial: 7.42, final: 7.42, locked: true },
  { mid: 41891, merchant_name: 'Prism Territory Shop', type: 'transaction', status: 'closed', initial: 19.26, final: 19.26, locked: true }
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
  amount: 0.01,
  error_flag: false,
  screen_type: 'summary',
  commission_initial: 0,
  commission_final: 0.01,
  transaction_locked: true
)

# ============================================================
# FILE 4: DataFlow Systems - Ready for Processing
# ============================================================
file4 = PaymentFile.create!(
  filename: 'DFLOW_SYSTEMS_demo_2024_06_20_5432.10.csv',
  region: 'uk',
  affiliate_network: 'DataFlow Systems',
  deposit_date: Date.new(2024, 6, 20),
  deposit_amount: 5432.10,
  payment_id: 'DF-SYS-0004-2024Q2',
  status: 'ready',
  file_status_label: 'READY'
)

# No transactions for ready file (not yet processed)

# ============================================================
# FILE 5: QuantumLink Pro - Processing
# ============================================================
file5 = PaymentFile.create!(
  filename: 'QUANTUMLINK_PRO_demo_2024_06_22_3210.50.xlsx',
  region: 'ca',
  affiliate_network: 'QuantumLink Pro',
  deposit_date: Date.new(2024, 6, 22),
  deposit_amount: 3210.50,
  payment_id: 'QLP-0005-2024Q2',
  status: 'processing',
  file_status_label: 'PROCESSING'
)

# No transactions for processing file

# ============================================================
# FILE 6: PulseNetwork Global - With DECLINED transactions
# ============================================================
file6 = PaymentFile.create!(
  filename: 'PULSE_GLOBAL_demo_2024_06_25_2156.78.xls',
  region: 'au',
  affiliate_network: 'PulseNetwork Global',
  deposit_date: Date.new(2024, 6, 25),
  deposit_amount: 2156.78,
  payment_id: 'PNG-0006-2024Q2',
  status: 'parsed',
  file_status_label: 'PARSED'
)

# DECLINED transactions
declined_data = [
  { mid: 50234, merchant_name: 'Apex Declined Retailer', type: 'declined_sales', status: 'declined', amount: 145.67 },
  { mid: 50234, merchant_name: 'Apex Declined Retailer', type: 'declined_commission', status: 'declined', amount: 14.57 },
  { mid: 50567, merchant_name: 'Zenith Rejected Vendor', type: 'declined_sales', status: 'declined', amount: 892.34 },
  { mid: 50567, merchant_name: 'Zenith Rejected Vendor', type: 'declined_commission', status: 'declined', amount: 89.23 }
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
