# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2026_05_10_000002) do
  create_table "payment_files", force: :cascade do |t|
    t.string "filename", null: false
    t.string "region", null: false
    t.string "affiliate_network", null: false
    t.date "deposit_date", null: false
    t.decimal "deposit_amount", precision: 12, scale: 2, null: false
    t.string "payment_id", null: false
    t.string "status", default: "new", null: false
    t.string "file_status_label", default: "NEW"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["affiliate_network"], name: "index_payment_files_on_affiliate_network"
    t.index ["region"], name: "index_payment_files_on_region"
    t.index ["status"], name: "index_payment_files_on_status"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "payment_file_id", null: false
    t.integer "mid", null: false
    t.string "merchant_name", null: false
    t.string "transaction_status", default: "paid", null: false
    t.string "transaction_type", null: false
    t.decimal "amount", precision: 12, scale: 2, null: false
    t.boolean "error_flag", default: false
    t.string "error_reason"
    t.string "screen_type", default: "display"
    t.decimal "commission_initial", precision: 12, scale: 2
    t.decimal "commission_final", precision: 12, scale: 2
    t.string "tenancy_tranx"
    t.decimal "campaign_amount", precision: 12, scale: 2
    t.boolean "transaction_locked", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["error_flag"], name: "index_transactions_on_error_flag"
    t.index ["mid"], name: "index_transactions_on_mid"
    t.index ["payment_file_id"], name: "index_transactions_on_payment_file_id"
    t.index ["screen_type"], name: "index_transactions_on_screen_type"
    t.index ["transaction_status"], name: "index_transactions_on_transaction_status"
  end

  add_foreign_key "transactions", "payment_files"
end
