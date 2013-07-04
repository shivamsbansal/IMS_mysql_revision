# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130704054902) do

  create_table "assets", :force => true do |t|
    t.string   "assetSrNo",  :limit => 20
    t.integer  "stock_id"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.string   "state",      :limit => 10
  end

  add_index "assets", ["stock_id"], :name => "index_assets_on_stock_id"

  create_table "associates", :force => true do |t|
    t.string   "name",          :limit => 50
    t.string   "email"
    t.date     "dateOfJoining"
    t.integer  "station_id"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "associates", ["station_id"], :name => "index_associates_on_station_id"

  create_table "categories", :force => true do |t|
    t.string   "nameCategory", :limit => 30
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "chalan_numbers", :force => true do |t|
    t.string   "chalanNo",   :limit => 8
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "issued_consumables", :force => true do |t|
    t.integer  "stock_id"
    t.integer  "associate_id"
    t.date     "dateOfIssue"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "quantity"
  end

  add_index "issued_consumables", ["associate_id"], :name => "index_issued_consumables_on_associate_id"
  add_index "issued_consumables", ["stock_id"], :name => "index_issued_consumables_on_stock_id"

  create_table "issued_items", :force => true do |t|
    t.integer  "asset_id"
    t.integer  "associate_id"
    t.date     "dateOfIssue"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "issued_items", ["asset_id"], :name => "index_issued_items_on_asset_id"
  add_index "issued_items", ["associate_id"], :name => "index_issued_items_on_associate_id"

  create_table "items", :force => true do |t|
    t.string   "nameItem",     :limit => 50
    t.integer  "lifeCycle"
    t.integer  "cost"
    t.integer  "leadTime"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "codeItem",     :limit => 10
    t.integer  "vendor_id"
    t.integer  "minimumStock"
    t.string   "assetType",    :limit => 15
    t.integer  "category_id"
    t.string   "brand",        :limit => 50
    t.string   "distinction",  :limit => 50
    t.string   "model",        :limit => 50
  end

  add_index "items", ["category_id"], :name => "index_items_on_category_id"
  add_index "items", ["vendor_id"], :name => "index_items_on_vendor_id"

  create_table "regions", :force => true do |t|
    t.string   "idRegion",   :limit => 10
    t.string   "nameRegion", :limit => 30
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "stations", :force => true do |t|
    t.string   "nameStation",    :limit => 30
    t.integer  "territory_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "addr1"
    t.string   "addr2"
    t.integer  "pincode"
    t.string   "contactDetails"
  end

  add_index "stations", ["territory_id"], :name => "index_stations_on_territory_id"

  create_table "stocks", :force => true do |t|
    t.integer  "item_id"
    t.integer  "station_id"
    t.string   "poId",            :limit => 20
    t.date     "poDate"
    t.string   "invoiceNo",       :limit => 20
    t.date     "invoiceDate"
    t.integer  "warrantyPeriod"
    t.integer  "initialStock"
    t.integer  "presentStock"
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.boolean  "inTransit",                     :default => false
    t.string   "comments"
    t.integer  "issuedStock"
    t.integer  "destroyedStock"
    t.integer  "soldStock"
    t.integer  "transferedStock"
    t.integer  "soldValue"
  end

  add_index "stocks", ["item_id"], :name => "index_stocks_on_item_id"
  add_index "stocks", ["station_id"], :name => "index_stocks_on_station_id"

  create_table "territories", :force => true do |t|
    t.string   "nameTerritory", :limit => 30
    t.integer  "region_id"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.string   "idTerritory",   :limit => 10
  end

  add_index "territories", ["region_id"], :name => "index_territories_on_region_id"

  create_table "transfers", :force => true do |t|
    t.integer  "from"
    t.integer  "to"
    t.date     "dateOfDispatch"
    t.date     "dateOfReceipt"
    t.integer  "stock_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "comments"
    t.string   "chalanNo",       :limit => 10
  end

  add_index "transfers", ["from"], :name => "index_transfers_on_from"
  add_index "transfers", ["stock_id"], :name => "index_transfers_on_stock_id"
  add_index "transfers", ["to"], :name => "index_transfers_on_to"

  create_table "users", :force => true do |t|
    t.string   "name",            :limit => 50
    t.string   "email"
    t.integer  "phone",           :limit => 8
    t.string   "password_digest"
    t.boolean  "admin"
    t.string   "remember_token"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "level_id"
    t.string   "level_type"
  end

  add_index "users", ["level_id", "level_type"], :name => "index_users_on_level_id_and_level_type"

  create_table "vendors", :force => true do |t|
    t.string   "nameVendor",  :limit => 50
    t.string   "email"
    t.integer  "phone",       :limit => 8
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "category_id"
  end

  add_index "vendors", ["category_id"], :name => "index_vendors_on_category_id"

end
