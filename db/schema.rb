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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170419164413) do

  create_table "contestants", force: :cascade do |t|
    t.integer  "contest_id", null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contest_id", "user_id"], name: "index_contestants_on_contest_id_and_user_id", unique: true
    t.index ["contest_id"], name: "index_contestants_on_contest_id"
    t.index ["user_id"], name: "index_contestants_on_user_id"
  end

  create_table "contests", force: :cascade do |t|
    t.string   "title",                             null: false
    t.integer  "penalty_time", default: 5,          null: false
    t.text     "standings",    default: "--- []\n", null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.datetime "start_at"
    t.datetime "end_at"
    t.text     "description",  default: "",         null: false
    t.index ["created_at"], name: "index_contests_on_created_at"
    t.index ["end_at"], name: "index_contests_on_end_at"
    t.index ["start_at"], name: "index_contests_on_start_at"
    t.index ["title"], name: "index_contests_on_title"
  end

  create_table "problem_sources", force: :cascade do |t|
    t.string   "problem_source",       null: false
    t.string   "latest_submission_id", null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "problems", force: :cascade do |t|
    t.string   "title",          null: false
    t.string   "url",            null: false
    t.string   "problem_source", null: false
    t.string   "problem_id",     null: false
    t.integer  "contest_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["contest_id"], name: "index_problems_on_contest_id"
  end

  create_table "submissions", force: :cascade do |t|
    t.string   "submission_id",  null: false
    t.string   "problem_id",     null: false
    t.string   "problem_source", null: false
    t.string   "status",         null: false
    t.integer  "user_id",        null: false
    t.datetime "date",           null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["date"], name: "index_submissions_on_date"
    t.index ["problem_id"], name: "index_submissions_on_problem_id"
    t.index ["status"], name: "index_submissions_on_status"
    t.index ["submission_id"], name: "index_submissions_on_submission_id"
    t.index ["user_id"], name: "index_submissions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "user_name",                                  null: false
    t.string   "atcoder_id",                                 null: false
    t.integer  "atcoder_rating",         default: 0,         null: false
    t.boolean  "admin",                  default: false
    t.string   "email",                  default: "",        null: false
    t.string   "encrypted_password",     default: "",        null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,         null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "name_color",             default: "#000000", null: false
    t.string   "aoj_id"
    t.index ["aoj_id"], name: "index_users_on_aoj_id", unique: true
    t.index ["atcoder_id"], name: "index_users_on_atcoder_id", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["user_name"], name: "index_users_on_user_name", unique: true
  end

end
