class PaymentFilesController < ApplicationController
  before_action :set_payment_file, only: [:display, :missing, :tenancy, :summary]

  # Screen 1: Upload List
  def index
    @payment_files = PaymentFile.all
  end

  # Screen 2: Display (Merchant Breakdown)
  def display
    @transactions = @payment_file.transactions.where(screen_type: 'display')
  end

  # Screen 3: Missing Transactions
  def missing
    @transactions = @payment_file.transactions.where(error_flag: true)
  end

  # Screen 4: Tenancy Settlement
  def tenancy
    @transactions = @payment_file.transactions.where(screen_type: 'tenancy')
  end

  # Screen 5: Summary
  def summary
    @transactions = @payment_file.transactions.where(screen_type: 'summary')
  end

  private

  def set_payment_file
    @payment_file = PaymentFile.find(params[:id])
  end
end