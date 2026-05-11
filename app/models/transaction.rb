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