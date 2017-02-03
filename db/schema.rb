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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170202061942) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.string   "body"
    t.integer  "person_id"
    t.integer  "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "comments", ["person_id"], name: "index_comments_on_person_id", using: :btree
  add_index "comments", ["post_id"], name: "index_comments_on_post_id", using: :btree

  create_table "division_recs", force: :cascade do |t|
    t.integer  "division_id"
    t.integer  "rec_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "division_recs", ["division_id"], name: "index_division_recs_on_division_id", using: :btree
  add_index "division_recs", ["rec_id"], name: "index_division_recs_on_rec_id", using: :btree

  create_table "division_supergroups", force: :cascade do |t|
    t.integer  "division_id"
    t.integer  "supergroup_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "division_supergroups", ["division_id"], name: "index_division_supergroups_on_division_id", using: :btree
  add_index "division_supergroups", ["supergroup_id"], name: "index_division_supergroups_on_supergroup_id", using: :btree

  create_table "divisions", force: :cascade do |t|
    t.string   "name"
    t.string   "short_name"
    t.string   "logo"
    t.string   "colour1"
    t.string   "colour2"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "follows", force: :cascade do |t|
    t.string   "follower_type"
    t.integer  "follower_id"
    t.string   "followable_type"
    t.integer  "followable_id"
    t.datetime "created_at"
  end

  add_index "follows", ["followable_id", "followable_type"], name: "fk_followables", using: :btree
  add_index "follows", ["follower_id", "follower_type"], name: "fk_follows", using: :btree

  create_table "likes", force: :cascade do |t|
    t.string   "liker_type"
    t.integer  "liker_id"
    t.string   "likeable_type"
    t.integer  "likeable_id"
    t.datetime "created_at"
  end

  add_index "likes", ["likeable_id", "likeable_type"], name: "fk_likeables", using: :btree
  add_index "likes", ["liker_id", "liker_type"], name: "fk_likes", using: :btree

  create_table "mentions", force: :cascade do |t|
    t.string   "mentioner_type"
    t.integer  "mentioner_id"
    t.string   "mentionable_type"
    t.integer  "mentionable_id"
    t.datetime "created_at"
  end

  add_index "mentions", ["mentionable_id", "mentionable_type"], name: "fk_mentionables", using: :btree
  add_index "mentions", ["mentioner_id", "mentioner_type"], name: "fk_mentions", using: :btree

  create_table "messages", force: :cascade do |t|
    t.text     "body"
    t.string   "display_name"
    t.integer  "person_id",    null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "people", force: :cascade do |t|
    t.string   "title"
    t.text     "address"
    t.string   "mobile"
    t.string   "fax"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
    t.string   "first_name"
    t.string   "last_name"
    t.string   "attachment"
    t.string   "gender"
    t.integer  "union_id"
    t.string   "country"
    t.string   "languages"
  end

  add_index "people", ["email"], name: "index_people_on_email", unique: true, using: :btree
  add_index "people", ["invitation_token"], name: "index_people_on_invitation_token", unique: true, using: :btree
  add_index "people", ["invitations_count"], name: "index_people_on_invitations_count", using: :btree
  add_index "people", ["invited_by_id"], name: "index_people_on_invited_by_id", using: :btree
  add_index "people", ["reset_password_token"], name: "index_people_on_reset_password_token", unique: true, using: :btree
  add_index "people", ["union_id"], name: "index_people_on_union_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.text     "body"
    t.string   "attachment"
    t.integer  "person_id"
    t.integer  "parent_id"
    t.string   "parent_type"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "posts", ["parent_id"], name: "index_posts_on_parent_id", using: :btree
  add_index "posts", ["parent_type", "parent_id"], name: "index_posts_on_parent_type_and_parent_id", using: :btree
  add_index "posts", ["person_id"], name: "index_posts_on_person_id", using: :btree

  create_table "recs", force: :cascade do |t|
    t.string   "name"
    t.string   "tags"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "attachment"
    t.string   "coverage"
    t.string   "union"
    t.string   "company"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "company_id"
    t.integer  "union_id"
    t.integer  "person_id"
    t.boolean  "multi_site"
    t.boolean  "grievance_handling"
    t.text     "grievance_handling_clause"
    t.boolean  "union_mandate"
    t.text     "union_mandate_clause"
    t.boolean  "anti_precariat"
    t.text     "anti_precariat_clause"
    t.text     "other_provisions"
    t.boolean  "taking_action"
    t.string   "nature_of_operation"
    t.boolean  "specific_rights"
    t.text     "specific_rights_clause"
    t.integer  "followers_count",           default: 0
    t.string   "grievance_handling_page"
    t.string   "union_mandate_page"
    t.string   "anti_precariat_page"
    t.string   "specific_rights_page"
    t.boolean  "health_and_safety"
    t.string   "health_and_safety_page"
    t.text     "health_and_safety_clause"
  end

  add_index "recs", ["company_id"], name: "index_recs_on_company_id", using: :btree
  add_index "recs", ["person_id"], name: "index_recs_on_person_id", using: :btree
  add_index "recs", ["union_id"], name: "index_recs_on_union_id", using: :btree

  create_table "supergroups", force: :cascade do |t|
    t.string   "name"
    t.string   "type"
    t.string   "www"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "banner"
    t.string   "logo"
    t.string   "short_name"
    t.integer  "followers_count", default: 0
    t.string   "country"
  end

  add_foreign_key "comments", "people"
  add_foreign_key "comments", "posts"
  add_foreign_key "division_recs", "divisions"
  add_foreign_key "division_recs", "recs"
  add_foreign_key "division_supergroups", "divisions"
  add_foreign_key "division_supergroups", "supergroups"
  add_foreign_key "messages", "people"
  add_foreign_key "people", "supergroups", column: "union_id"
  add_foreign_key "posts", "people"
  add_foreign_key "recs", "people"
  add_foreign_key "recs", "supergroups", column: "company_id"
  add_foreign_key "recs", "supergroups", column: "union_id"
end
