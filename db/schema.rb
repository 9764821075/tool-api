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

ActiveRecord::Schema.define(version: 2021_07_24_194406) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "unaccent"
  enable_extension "uuid-ossp"

  create_table "activities", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "location"
    t.string "city"
    t.text "notes"
    t.boolean "deleted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "number_of_people"
    t.integer "date_year"
    t.integer "date_month"
    t.integer "date_day"
    t.string "region"
    t.string "country_code"
    t.string "zip_code"
    t.uuid "primary_photo_id"
    t.index ["name"], name: "index_activities_on_name"
    t.index ["primary_photo_id"], name: "index_activities_on_primary_photo_id"
  end

  create_table "addresses", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "line1"
    t.string "zip_code"
    t.string "city"
    t.boolean "deleted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "region"
    t.string "country_code"
    t.index ["name"], name: "index_addresses_on_name"
  end

  create_table "export_results", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "file_id"
    t.string "file_filename"
    t.integer "file_size"
    t.string "file_content_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "duration"
    t.integer "file_count"
  end

  create_table "logos", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "organization_id"
    t.string "file_id"
    t.string "file_filename"
    t.integer "file_size"
    t.string "file_content_type"
    t.integer "width"
    t.integer "height"
    t.boolean "deleted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color"
  end

  create_table "note_joins", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "note_id"
    t.uuid "noteable_id"
    t.string "noteable_type"
    t.boolean "deleted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["noteable_id", "noteable_type"], name: "index_note_joins_on_noteable_id_and_noteable_type"
  end

  create_table "notes", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.text "text"
    t.boolean "deleted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "title"
    t.date "date"
  end

  create_table "organization_activities", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "activity_id"
    t.uuid "organization_id"
    t.string "role"
    t.boolean "deleted", default: false
    t.index ["activity_id"], name: "index_organization_activities_on_activity_id"
    t.index ["organization_id"], name: "index_organization_activities_on_organization_id"
  end

  create_table "organization_addresses", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "organization_id"
    t.uuid "address_id"
    t.boolean "deleted", default: false
    t.integer "since_month"
    t.integer "since_year"
    t.integer "until_month"
    t.integer "until_year"
    t.jsonb "statuses", default: [], null: false
    t.index ["address_id"], name: "index_organization_addresses_on_address_id"
    t.index ["organization_id"], name: "index_organization_addresses_on_organization_id"
  end

  create_table "organization_associations", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "organization_id"
    t.uuid "person_id"
    t.string "position"
    t.integer "since_month"
    t.integer "since_year"
    t.integer "until_month"
    t.integer "until_year"
    t.boolean "deleted", default: false
    t.index ["organization_id"], name: "index_organization_associations_on_organization_id"
    t.index ["person_id"], name: "index_organization_associations_on_person_id"
  end

  create_table "organizations", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name", null: false
    t.boolean "deleted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ancestry"
    t.string "names_depth_cache"
    t.string "shortname"
    t.index ["ancestry"], name: "index_organizations_on_ancestry"
    t.index ["name"], name: "index_organizations_on_name", unique: true
  end

  create_table "pdf_joins", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "pdf_id"
    t.uuid "pdfable_id"
    t.string "pdfable_type"
    t.boolean "deleted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pdfable_id", "pdfable_type"], name: "index_pdf_joins_on_pdfable_id_and_type"
  end

  create_table "pdfs", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "file_id"
    t.string "file_filename"
    t.integer "file_size"
    t.string "file_content_type"
    t.integer "width"
    t.integer "height"
    t.text "description"
    t.boolean "deleted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "thumbnail_id"
    t.string "thumbnail_filename"
    t.integer "thumbnail_size"
    t.string "thumbnail_content_type"
    t.integer "thumbnail_width"
    t.integer "thumbnail_height"
    t.string "color"
  end

  create_table "people", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name", null: false
    t.text "notes"
    t.boolean "deleted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone"
    t.string "email"
    t.date "date_of_birth"
    t.boolean "noname", default: false
    t.string "birth_name"
    t.string "place_of_birth"
    t.date "date_of_death"
    t.string "nicknames", default: [], array: true
    t.uuid "primary_photo_id"
    t.index ["primary_photo_id"], name: "index_people_on_primary_photo_id"
  end

  create_table "person_activities", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "activity_id"
    t.uuid "person_id"
    t.string "role"
    t.boolean "deleted", default: false
    t.index ["activity_id"], name: "index_person_activities_on_activity_id"
    t.index ["person_id"], name: "index_person_activities_on_person_id"
  end

  create_table "person_addresses", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "person_id"
    t.uuid "address_id"
    t.boolean "deleted", default: false
    t.integer "since_month"
    t.integer "since_year"
    t.integer "until_month"
    t.integer "until_year"
    t.index ["address_id"], name: "index_person_addresses_on_address_id"
    t.index ["person_id"], name: "index_person_addresses_on_person_id"
  end

  create_table "photo_joins", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "photo_id"
    t.uuid "photoable_id"
    t.string "photoable_type"
    t.boolean "deleted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["photoable_id", "photoable_type"], name: "index_photo_joins_on_photoable_id_and_photoable_type"
  end

  create_table "photo_tags", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "person_id", null: false
    t.uuid "photo_id", null: false
    t.integer "top", null: false
    t.integer "left", null: false
    t.integer "width", null: false
    t.integer "height", null: false
    t.boolean "deleted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_photo_tags_on_person_id"
    t.index ["photo_id"], name: "index_photo_tags_on_photo_id"
  end

  create_table "photos", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "person_id"
    t.string "file_id"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "file_filename"
    t.integer "file_size"
    t.string "file_content_type"
    t.uuid "activity_id"
    t.integer "width"
    t.integer "height"
    t.boolean "deleted", default: false
    t.string "color"
    t.index ["activity_id"], name: "index_photos_on_activity_id"
    t.index ["person_id"], name: "index_photos_on_person_id"
  end

  create_table "profiles", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "person_id"
    t.string "service", null: false
    t.string "username", null: false
    t.boolean "deleted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "organization_id"
    t.index ["organization_id"], name: "index_profiles_on_organization_id"
    t.index ["person_id"], name: "index_profiles_on_person_id"
  end

  create_table "relationships", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "person_id"
    t.uuid "friend_id"
    t.integer "status", default: 0
    t.text "info"
    t.boolean "deleted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["friend_id"], name: "index_relationships_on_friend_id"
    t.index ["person_id"], name: "index_relationships_on_person_id"
  end

  create_table "screenshot_joins", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "screenshot_id"
    t.uuid "screenshotable_id"
    t.string "screenshotable_type"
    t.boolean "deleted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["screenshotable_id", "screenshotable_type"], name: "index_screenshot_joins_on_screenshotable_id_and_type"
  end

  create_table "screenshots", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "file_id"
    t.string "file_filename"
    t.integer "file_size"
    t.string "file_content_type"
    t.integer "width"
    t.integer "height"
    t.text "description"
    t.boolean "deleted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color"
  end

  create_table "sessions", id: :serial, force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "source_authors", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "service", null: false
    t.string "username", null: false
    t.string "author", null: false
    t.boolean "deleted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service", "username"], name: "index_source_authors_on_service_and_username", unique: true, where: "((deleted = false) OR (deleted IS NULL))"
  end

  create_table "source_joins", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "source_id"
    t.uuid "sourceable_id"
    t.string "sourceable_type"
    t.boolean "deleted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sourceable_id", "sourceable_type"], name: "index_source_joins_on_sourceable_id_and_sourceable_type"
  end

  create_table "sources", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.string "url"
    t.boolean "deleted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "published_at"
    t.text "text"
    t.string "author"
    t.integer "source_joins_count"
    t.index ["url"], name: "index_sources_on_url", unique: true
  end

  create_table "trash", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "deleted_model_name", null: false
    t.uuid "deleted_model_id", null: false
    t.text "deleted_model_info"
    t.uuid "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_model_name", "deleted_model_id"], name: "index_trash_on_deleted_model_name_and_deleted_model_id"
    t.index ["user_id"], name: "index_trash_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "username", null: false
    t.string "password_digest"
    t.integer "failed_attempts", default: 0, null: false
    t.datetime "locked_at"
    t.boolean "deleted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "videos", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "person_id"
    t.uuid "activity_id"
    t.string "file_id"
    t.text "description"
    t.string "file_filename"
    t.integer "file_size"
    t.string "file_content_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "deleted", default: false
    t.string "thumbnail_id"
    t.string "thumbnail_filename"
    t.integer "thumbnail_size"
    t.string "thumbnail_content_type"
    t.integer "thumbnail_width"
    t.integer "thumbnail_height"
    t.integer "width"
    t.integer "height"
    t.string "color"
    t.index ["activity_id"], name: "index_videos_on_activity_id"
    t.index ["person_id"], name: "index_videos_on_person_id"
  end

  create_table "workplaces", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "person_id", null: false
    t.string "name", null: false
    t.string "position"
    t.string "line1"
    t.string "zip_code"
    t.string "city"
    t.integer "since_month"
    t.integer "since_year"
    t.integer "until_month"
    t.integer "until_year"
    t.boolean "deleted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "region"
    t.string "country_code"
    t.index ["name"], name: "index_workplaces_on_name"
    t.index ["person_id"], name: "index_workplaces_on_person_id"
  end

end
