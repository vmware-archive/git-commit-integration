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

ActiveRecord::Schema.define(version: 20150603014423) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "commits", force: :cascade do |t|
    t.string   "data",                     null: false
    t.string   "sha",                      null: false
    t.string   "patch_identifier"
    t.string   "message",                  null: false
    t.integer  "author_github_user_id",    null: false
    t.datetime "author_date",              null: false
    t.integer  "committer_github_user_id", null: false
    t.datetime "committer_date",           null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "repo_id",                  null: false
  end

  create_table "deploy_commits", force: :cascade do |t|
    t.string   "deployed_sha"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "deploys", force: :cascade do |t|
    t.string   "name"
    t.string   "uri"
    t.string   "extract_pattern"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "external_link_commits", force: :cascade do |t|
    t.integer  "external_link_id", null: false
    t.integer  "commit_id",        null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "external_id",      null: false
    t.string   "external_uri",     null: false
  end

  create_table "external_link_repos", force: :cascade do |t|
    t.integer  "external_link_id", null: false
    t.integer  "repo_id",          null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "external_links", force: :cascade do |t|
    t.string   "description",            null: false
    t.string   "extract_pattern",        null: false
    t.string   "uri_template",           null: false
    t.string   "replace_pattern",        null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.datetime "commits_processed_thru"
  end

  create_table "github_users", force: :cascade do |t|
    t.string   "username",   null: false
    t.string   "email",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parent_commits", force: :cascade do |t|
    t.integer  "commit_id"
    t.string   "sha",                                    null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "child_commit_id",                        null: false
    t.integer  "child_secondary_sort_order", default: 1, null: false
  end

  create_table "push_commits", force: :cascade do |t|
    t.integer  "push_id",    null: false
    t.integer  "commit_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pushes", force: :cascade do |t|
    t.string   "payload"
    t.string   "head_commit"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "repo_id",                           null: false
    t.boolean  "commits_processed", default: false, null: false
    t.integer  "ref_id",                            null: false
  end

  create_table "ref_commits", force: :cascade do |t|
    t.integer  "ref_id",     null: false
    t.integer  "commit_id",  null: false
    t.boolean  "exists",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "refs", force: :cascade do |t|
    t.string   "reference"
    t.integer  "repo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "repos", force: :cascade do |t|
    t.integer  "user_id",           null: false
    t.text     "url",               null: false
    t.text     "hook"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "github_identifier", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",               default: "", null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "github_app_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
