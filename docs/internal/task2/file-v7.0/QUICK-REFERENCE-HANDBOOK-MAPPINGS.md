# Quick Reference - Real System Mappings from Handbook

## 📋 File Status Progression (Real from Handbook)

```
NEW (Upload Payment File)
  ↓ [PARSE button]
READY (Ready for Processing)
  ↓ [Backend job every 30 min]
PROCESSING (File parsing in progress)
  ↓ [Success]
PARSED (File parsing completed successfully)
  ↓ [DISPLAY button] → View transactions
  ↓ [MISSING button] → View missing transactions
TRAN RECONCILING (Ready for transaction reconciliation)
  ↓ [Backend job every 30 min]
PROCESSING TRAN RECONCILING (Transaction reconciliation in progress)
  ↓ [Success]
PARTIALLY RECONCILED (Transactions reconciled, tenancies pending)
  ↓ [LOAD button] → Tenancy Settlement
RECONCILING (Ready for full reconciliation)
  ↓ [Backend job every 30 min]
PROCESSING RECONCILING (Reconciliation in progress)
  ↓ [Success]
RECONCILED (File reconciliation completed successfully)
  ↓ [REPORT button] → View summary
```

---

## 💳 Transaction Statuses (Real from Handbook)

### PAID
- Successfully matched to existing transaction
- Ready to be reconciled
- Includes: Paid Sales, Paid Commissions

### DECLINED
- Sent in payment file with declined status
- **NOTE:** Only Commission Junction sends declined data
- Includes: Declined Sales, Declined Commissions

### MISSING
- Could not be matched with existing records
- Include specific reason codes
- Includes: Missing Sales, Missing Commissions
- **Legacy Note:** Transactions with COMMISSION MISMATCH previously under PAID now under MISSING

### CLOSED
- Already settled or paid in system
- Previously paid transactions
- Includes: Closed Sales, Closed Commissions
- **Legacy Note:** Transactions marked "Transaction Already Closed" previously under MISSING now under CLOSED

---

## 🚨 Missing Transaction Reasons (Real from Handbook)

### 1. COMMISSION_MISMATCH
- **What:** Commission amount in payment file differs from system
- **Resolution:** Reconciled at new dollar amount from payment file
- **Status:** Can appear in PAID (if not fully processed) or MISSING screen (if partially processed)

### 2. TRANSACTION_NOT_FOUND
- **What:** Transaction in payment file doesn't exist in system
- **Resolution:** Create new transaction to match payment file info

### 3. AGGREGATOR_TRANSACTION_ID_NOT_FOUND
- **What:** Transaction found on some details but transaction ID doesn't match
- **Resolution:** Classified as unmatched, not reconciled against existing transaction

### 4. AGGREGATOR_MISMATCH
- **What:** Transaction refers to aggregator that doesn't match expected details
- **Special Case:** If already fully processed = "All transactions with AggTxID already closed"
- **Resolution:** Classified as unmatched

### 5. UNKNOWN_REASON
- **What:** System unable to determine why transaction couldn't be matched
- **Resolution:** Classified as unmatched

### 6. INVALID_DATE
- **What:** Date in payment file missing or incorrectly formatted
- **Example:** "Invalid tx_date"
- **Resolution:** Classified as unmatched

### 7. INVALID_SALE_VALUE
- **What:** Sale amount missing or not in usable format
- **Example:** "INVALID_SALE - ABCD"
- **Resolution:** Classified as unmatched

### 8. INVALID_COMMISSION_VALUE
- **What:** Commission amount is zero or not in usable format
- **Resolution:** Classified as unmatched

### 9. TRANSACTION_ALREADY_CLOSED
- **What:** Transaction already fully processed and marked as closed
- **Resolution:** Classified as unmatched
- **Legacy Note:** Previously in MISSING, now in CLOSED column

---

## 🏢 Real Affiliate Networks (From Handbook)

- Commission Junction
- Linkshare
- Qantas
- WebLogic

**Important Business Rule:**
- DECLINED transactions only sent by Commission Junction

---

## 📁 Real File Naming Format (From Handbook Examples)

```
[Network]-[Region]_[Testing/Descriptor]_[Date]_[Amount].[ext]

Examples from handbook:
- Qantas-PHG-AU_testing1_2024_06_13_129259.03.xls
- Affiliate-Future-UK_2023_06_21_687.60-055eq45.xls
- CJ-UK_2024_06_13_19711.69.xls
```

**Pattern Components:**
- Network: Commission Junction, Linkshare, Qantas, WebLogic, etc.
- Region: UK, CA, AU, US
- Testing/Descriptor: testing1, testing2, or specific identifier
- Date: YYYY_MM_DD format
- Amount: Deposit amount (2-3 decimal places)
- Extension: .xls, .xlsx, .xml, .csv, .json

---

## 🔍 Error Handling from Handbook

### Error Statuses (File Level)
- MAPPING ERROR - <error description>
- MAPPING ERROR - Payment ID not found
- PARSING ERROR - PLEASE CONTACT SUPPORT TEAM
- RECONCILING ERROR - PLEASE CONTACT SUPPORT TEAM

### Error Handling Workflow
```
NEW → READY → PROCESSING → ERROR
                              ↓
                          REMOVE (User removes file)
                              ↓
                           Re-upload
                              ↓
                            Back to NEW
```

---

## 📊 Real Example from Handbook

**File:** Qantas-PHG-AU_testing1_2024_06_13_129259.03.xls
**Region:** Australia
**Affiliate:** Qantas
**Amount:** 129259.03
**Status:** PARSED with MISSING flag

**Merchants Included:**
- Hotelopia UK
- Adore Beauty
- Charlotte Tilbury
- Eva
- FARFETCH
- Healthylife
- M.J. Bale
- And more...

**Transaction Statuses:**
- PAID: Multiple sales and commissions
- MISSING: Some transactions with reasons
- CLOSED: Already settled transactions

---

## 🎯 Key Business Rules (From Handbook)

1. **Single File Processing:** Each file processed one at a time by backend jobs
2. **Backend Jobs:** Run every 30 minutes, pick only one file at a time
3. **Declined Transactions:** Only Commission Junction sends these
4. **Commission Mismatch:** Legacy migrations - moved from PAID to MISSING category
5. **Already Closed Transactions:** Legacy migrations - moved from MISSING to CLOSED category
6. **Tenancy Processing:** Must be completed in one transaction - no partial settlements
7. **Unmatched Amounts:** Include commissions for records with status CLOSED or MISSING
8. **Email Notifications:** Sent on errors and successful completion

---

## 💾 Our Fake Data Implementation

### Uses REAL from Handbook:
✅ Affiliate networks: Commission Junction, Linkshare, Qantas, WebLogic
✅ File statuses: new, ready, processing, parsed, partial_reconciled, full_reconciled
✅ Transaction statuses: PAID, DECLINED, MISSING, CLOSED
✅ Error reasons: Exact from handbook
✅ Business rules: DECLINED only from CJ
✅ File naming format: Real format with fake dates/amounts
✅ Error handling workflow: Real from handbook

### Uses FAKE for Privacy:
✅ Merchant names: StyleHub UK, ShopMax Ltd, RetailPro London, etc.
✅ MID numbers: 10234, 10567, 10891, etc.
✅ Amounts: Realistic ranges but fictional
✅ Commission rates: 10% (realistic)
✅ All specific identifiers: Made up

---

## 📝 Database Schema (From Code Files)

### payment_files table
```ruby
t.string :filename                    # Real format
t.string :region                      # uk, ca, us, au
t.string :affiliate_network           # Real networks
t.date :deposit_date
t.decimal :deposit_amount
t.string :payment_id
t.string :status                      # new, ready, processing, parsed, etc.
t.string :file_status_label           # Display label
```

### transactions table
```ruby
t.references :payment_file
t.integer :mid                        # Merchant ID
t.string :merchant_name
t.string :transaction_status          # paid, declined, missing, closed
t.string :transaction_type            # paid_sales, paid_commission, etc.
t.decimal :amount
t.boolean :error_flag
t.string :error_reason                # Real error reasons
t.string :screen_type                 # display, missing, tenancy, summary
t.decimal :commission_initial
t.decimal :commission_final
t.string :tenancy_tranx
t.decimal :campaign_amount
t.boolean :transaction_locked
```

---

## 🚀 Ready to Implement!

All this real system knowledge is now embedded in:
- Models with proper enums and constants
- Seed data with realistic scenarios
- Error handling matching handbook
- Business rules implemented correctly

**You're ready to build the UI on top of this solid foundation!** ✓
