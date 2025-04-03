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

ActiveRecord::Schema[8.0].define(version: 2025_04_03_022640) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "activities", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "action"
    t.string "target_name"
    t.string "target_type", null: false
    t.bigint "target_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["target_type", "target_id"], name: "index_activities_on_target"
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "applications", force: :cascade do |t|
    t.string "name"
    t.string "repo_url"
    t.string "hostname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "channels", force: :cascade do |t|
    t.bigint "realm_id", null: false
    t.string "name"
    t.text "description"
    t.string "channel_type"
    t.boolean "is_private"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["realm_id"], name: "index_channels_on_realm_id"
  end

  create_table "components", force: :cascade do |t|
    t.string "name"
    t.string "kind"
    t.bigint "application_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_id"], name: "index_components_on_application_id"
  end

  create_table "direct_message_participants", force: :cascade do |t|
    t.bigint "direct_message_thread_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["direct_message_thread_id"], name: "index_direct_message_participants_on_direct_message_thread_id"
    t.index ["user_id"], name: "index_direct_message_participants_on_user_id"
  end

  create_table "direct_message_threads", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_participants", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "user_id", null: false
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_participants_on_event_id"
    t.index ["user_id"], name: "index_event_participants_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.bigint "realm_id", null: false
    t.bigint "user_id", null: false
    t.string "title"
    t.text "description"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["realm_id"], name: "index_events_on_realm_id"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "friends", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "friend_id", null: false
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["friend_id"], name: "index_friends_on_friend_id"
    t.index ["user_id"], name: "index_friends_on_user_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "member_role"
    t.string "nickname"
    t.string "membershipable_type", null: false
    t.bigint "membershipable_id", null: false
    t.datetime "joined_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["membershipable_type", "membershipable_id"], name: "index_memberships_on_membershipable"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "content"
    t.string "attachment_url"
    t.boolean "is_pinned"
    t.string "messageable_type", null: false
    t.bigint "messageable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["messageable_type", "messageable_id"], name: "index_messages_on_messageable"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "source_type"
    t.string "source_id"
    t.string "notification_type"
    t.boolean "read"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "realms", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "icon"
    t.string "banner"
    t.bigint "user_id", null: false
    t.boolean "is_public"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_realms_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "user_agent"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "user_profiles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "username"
    t.string "display_name"
    t.string "avatar"
    t.text "bio"
    t.string "gaming_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_profiles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.boolean "verified", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "activities", "users"
  add_foreign_key "channels", "realms"
  add_foreign_key "components", "applications"
  add_foreign_key "direct_message_participants", "direct_message_threads"
  add_foreign_key "direct_message_participants", "users"
  add_foreign_key "event_participants", "events"
  add_foreign_key "event_participants", "users"
  add_foreign_key "events", "realms"
  add_foreign_key "events", "users"
  add_foreign_key "friends", "friends"
  add_foreign_key "friends", "users"
  add_foreign_key "memberships", "users"
  add_foreign_key "messages", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "realms", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "user_profiles", "users"
end
