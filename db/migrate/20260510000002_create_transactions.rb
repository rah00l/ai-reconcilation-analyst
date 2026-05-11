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

    add_index :transactions, :error_flag
    add_index :transactions, :screen_type
    add_index :transactions, :transaction_status
    add_index :transactions, :mid
  end
end