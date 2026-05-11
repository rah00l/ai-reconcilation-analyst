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