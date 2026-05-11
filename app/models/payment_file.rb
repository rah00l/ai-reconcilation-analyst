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