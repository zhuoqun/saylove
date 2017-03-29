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

ActiveRecord::Schema.define(:version => 20121101121826) do

  create_table "comments", :force => true do |t|
    t.string   "user_id"
    t.text     "content"
    t.string   "letter_id"
    t.boolean  "disable",    :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "email_options", :force => true do |t|
    t.string   "user_id"
    t.boolean  "echo",       :default => true
    t.boolean  "flower",     :default => false
    t.boolean  "comment",    :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "favorites", :force => true do |t|
    t.string   "user_id"
    t.string   "letter_id"
    t.boolean  "disable",    :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "flowers", :force => true do |t|
    t.string   "user_id"
    t.string   "letter_id"
    t.boolean  "disable",    :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "letters", :force => true do |t|
    t.string   "user_id"
    t.string   "contact_id"
    t.string   "contact_type"
    t.text     "content"
    t.integer  "flowers_cnt",  :default => 0
    t.boolean  "is_public",    :default => false
    t.boolean  "comments_on",  :default => false
    t.boolean  "is_draft",     :default => false
    t.boolean  "is_viewed",    :default => false
    t.boolean  "notified",     :default => false
    t.boolean  "has_echo",     :default => false
    t.boolean  "disable",      :default => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "notifications", :force => true do |t|
    t.string   "user_id"
    t.string   "letter_id"
    t.string   "category"
    t.integer  "count",      :default => 0
    t.boolean  "unread",     :default => true
    t.boolean  "notified",   :default => false
    t.boolean  "disable",    :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "providers", :force => true do |t|
    t.string   "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "url"
    t.string   "token"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "quotes", :force => true do |t|
    t.string   "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "user_name"
    t.string   "avatar"
    t.integer  "gender"
    t.string   "password"
    t.string   "email"
    t.boolean  "from_provider",        :default => true
    t.boolean  "disable",              :default => false
    t.string   "brief"
    t.string   "password_reset_token"
    t.datetime "password_sent_at"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

end
