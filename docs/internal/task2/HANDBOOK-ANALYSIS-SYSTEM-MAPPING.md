# Real Reconciliation System Analysis - From Handbook

## File Processing Statuses (From Handbook)

### Status Progression Flow
```
NEW 
  ↓ (PARSE button)
READY 
  ↓ (Backend job every 30 min)
PROCESSING 
  ↓ (Success)
PARSED
  ↓ (DISPLAY → view transactions)
  ↓ (MISSING → review missing transactions)
TRAN RECONCILING (After TRAN RECONCILE)
  ↓ (Backend job every 30 min)
PROCESSING TRAN RECONCILING
  ↓ (Success)
PARTIALLY RECONCILED
  ↓ (LOAD → Tenancy Settlement)
RECONCILING (After FULL RECONCILE)
  ↓ (Backend job every 30 min)
PROCESSING RECONCILING
  ↓ (Success)
RECONCILED (Final State)
```

### Error Statuses
- MAPPING ERROR - <error description>
- MAPPING ERROR - Payment ID not found
- PARSING ERROR - PLEASE CONTACT SUPPORT TEAM
- RECONCILING ERROR - PLEASE CONTACT SUPPORT TEAM

---

## Transaction Types (From Handbook - Display Screen)

### PAID Status Transactions
- Paid Sales
- Paid Commissions

### DECLINED Status Transactions
- Declined Sales
- Declined Commissions
(Note: Only Commission Junction sends declined data)

### MISSING Status Transactions
- Missing Sales
- Missing Commissions
(These are payments that couldn't be matched)

### CLOSED Status Transactions
- Closed Sales
- Closed Commissions
(Already settled/paid transactions)

---

## Missing Transaction Reasons (Screen 3 - From Handbook)

### Actual Reasons from Handbook:

1. **COMMISSION MISMATCH**
   - Commission amount in payment file differs from system
   - Can show in PAID column (if not fully processed)
   - Can show in MISSING screen (if partially processed)
   - Resolution: Reconciled at new dollar amount from payment file

2. **TRANSACTION NOT FOUND**
   - Transaction in payment file doesn't exist in system
   - Resolution: Create new transaction to match payment file

3. **AGGREGATOR TRANSACTION ID NOT FOUND**
   - Transaction found on some details, but transaction ID doesn't match
   - Resolution: Classified as "unmatched", not reconciled against existing txn

4. **AGGREGATOR MISMATCH / MISMATCH - AGGREGATOR NOT FOUND**
   - Transaction refers to aggregator that doesn't match expected details
   - Special case: If already fully processed = "All transactions with AggTxID already closed"
   - Resolution: Classified as "unmatched"

5. **UNKNOWN REASON**
   - System unable to determine why transaction couldn't be matched
   - Resolution: Classified as "unmatched"

6. **INVALID DATE**
   - Date in payment file missing or incorrectly formatted
   - Example: "Invalid tx_date"
   - Resolution: Classified as "unmatched"

7. **INVALID SALE VALUE**
   - Sale amount missing or not in usable format
   - Resolution: Classified as "unmatched"

8. **INVALID COMMISSION VALUE**
   - Commission amount is zero or not in usable format
   - Resolution: Classified as "unmatched"

9. **TRANSACTION ALREADY CLOSED**
   - Transaction already fully processed and marked as closed
   - Legacy note: Previously in MISSING, now in CLOSED column
   - Resolution: Classified as "unmatched"

---

## Unmatched Transaction Reasons (From Handbook - Screen 5)

### Reconciled Transactions Reasons:
1. PAID - Already paid but not reconciled earlier
2. MISSING (Transaction not found) - Could not find in system
3. MISSING (Commission Mismatch) - Commission amount doesn't match
4. Tenancy/BMG - Reconciled tenancy-related transactions
5. UNMATCHED (Bonus Amount) - Bonus calculated as (Deposit - (Total Txn Commission + Tenancy + VAT))
6. VAT - Reconciled VAT amounts

### Unmatched Transactions Reasons:
1. ALREADY CLOSED - Transaction was already closed and reconciled
2. Aggregator Tran ID not found - Aggregator transaction ID not found
3. Aggregator Mismatch - Aggregator network doesn't match
4. Unknown - System unable to identify transaction
5. INVALID SALE - ABCD - Sale value not in valid format
6. Invalid Commission - Commission value not in valid format
7. INVALID DATE - HJJS - Date format invalid
8. (More as new reasons are discovered)

---

## Payment File Examples from Handbook Screenshots

### Example 1: Qantas Payment File
- File: `Qantas-PHG-AU_testing1_2024_06_13_129259.03.xls`
- Region: Australia
- Affiliate: Qantas
- Amount: 129259.03
- Status: PARSED with MISSING flag
- Merchants: Hotelopia UK, Adore Beauty, Charlotte Tilbury, Eva, FARFETCH, etc.

### Example 2: Commission Junction File
- Merchants: Various UK/AU retailers
- Transactions: Mix of PAID, DECLINED, MISSING, CLOSED
- Missing reasons: COMMISSION MISMATCH, AGGREGATOR TRANSACTION ID NOT FOUND

---

## Current Fake Data Issues (Needs Adjustment)

### What Needs Updating:

1. ❌ **File Names**: Not matching real format
   - Current: `AffCentral-UK_2026_02_18_19711.69.xlsx`
   - Real format: `Qantas-PHG-AU_testing1_2024_06_13_129259.03.xls`
   - Pattern: `[Affiliate]-[Region]_[TestDescriptor]_[Date]_[Amount].ext`

2. ❌ **Affiliate Networks**: Fake names don't match handbook
   - Real networks: Commission Junction, Linkshare, Qantas, WL (Weblogic?)
   - Should use: Real names but with fake data/merchants

3. ❌ **Error Reasons**: Need exact match to handbook
   - Current: Generic error strings
   - Should be: Exact from handbook (COMMISSION MISMATCH, AGGREGATOR TRANSACTION ID NOT FOUND, etc.)

4. ❌ **Transaction Types**: Need proper status columns
   - Current: Simple paid_sales, paid_commission
   - Should track: PAID, DECLINED, MISSING, CLOSED with subtypes

5. ❌ **Error Descriptions**: Need format from handbook
   - Current: Simple reason field
   - Should include: Specific reason codes (e.g., "Invalid tx_date", "AGGREGATOR MISMATCH")

---

## Recommendation

### Keep Fake Data But Update To Match Real System:

✅ **USE REAL** (for authenticity):
- Real affiliate network names (Commission Junction, Linkshare, Qantas)
- Real error reason names (from handbook)
- Real transaction status names (PAID, DECLINED, MISSING, CLOSED)
- Real file naming patterns (with fake dates/amounts)

✅ **USE FAKE** (for privacy):
- Merchant names (StyleHub UK, ShopMax Ltd, etc. - already done)
- Merchant IDs (MID numbers)
- File amounts (realistic ranges)
- Specific transaction details

---

## Next Steps

I will rebuild TASK2-ALL-CODE-FILES-FAKE-DATA.md with:

1. ✅ Real affiliate networks: Commission Junction, Linkshare, Qantas
2. ✅ Real file naming format: `[Network]-[Region]_[Descriptor]_[Date]_[Amount].ext`
3. ✅ Real error reasons: Exact from handbook
4. ✅ Real transaction status columns: PAID, DECLINED, MISSING, CLOSED
5. ✅ Real transaction subtypes: Paid Sales, Paid Commission, etc.
6. ✅ Fake merchants: Keep current fake names (StyleHub, ShopMax, etc.)
7. ✅ Fake amounts: Keep realistic ranges
8. ✅ Fake MIDs: Keep 5-digit format

---

## Status Mapping in Code

### Current Models Need Adjustment:

**PaymentFile statuses** - Keep all (they're real from handbook):
- new, ready, processing, parsed, partial_reconciled, full_reconciled

**Transaction types** - Need to add proper status field:
- Add: status (PAID, DECLINED, MISSING, CLOSED)
- Keep: transaction_type (what type of transaction: sales, commission, bonus, etc.)

**Error reasons** - Update to real values from handbook:
- COMMISSION_MISMATCH
- TRANSACTION_NOT_FOUND
- AGGREGATOR_TRANSACTION_ID_NOT_FOUND
- AGGREGATOR_MISMATCH
- UNKNOWN_REASON
- INVALID_DATE
- INVALID_SALE_VALUE
- INVALID_COMMISSION_VALUE
- TRANSACTION_ALREADY_CLOSED

---

## Confirmation Needed

Should I rebuild the code files with:

✅ Real affiliate network names (Commission Junction, Linkshare, Qantas)
✅ Real error reasons from handbook
✅ Real file naming patterns (with fake dates/amounts)
✅ Keep fake merchant names & IDs for privacy
✅ Maintain realistic amounts

**Proceed with this approach?**
