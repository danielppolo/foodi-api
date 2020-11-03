# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_12_18_065649) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cuisines", force: :cascade do |t|
    t.bigint "restaurant_id"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_cuisines_on_category_id"
    t.index ["restaurant_id"], name: "index_cuisines_on_restaurant_id"
  end

  create_table "ingredients", force: :cascade do |t|
    t.string "name"
    t.integer "carbs_per_kilo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "meal_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["meal_id"], name: "index_likes_on_meal_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "meals", force: :cascade do |t|
    t.string "name"
    t.string "image"
    t.string "description"
    t.boolean "is_kosher"
    t.boolean "is_vegetarian"
    t.boolean "is_vegan"
    t.boolean "is_halal"
    t.integer "price_cents"
    t.integer "preparation_time"
    t.boolean "is_beverage"
    t.float "popularity"
    t.bigint "restaurant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_meals_on_restaurant_id"
  end

  create_table "portions", force: :cascade do |t|
    t.bigint "ingredient_id"
    t.bigint "meal_id"
    t.float "grams"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ingredient_id"], name: "index_portions_on_ingredient_id"
    t.index ["meal_id"], name: "index_portions_on_meal_id"
  end

  create_table "restaurants", force: :cascade do |t|
    t.string "schedule"
    t.integer "popularity"
    t.string "logotype"
    t.integer "store_type"
    t.string "image"
    t.string "name"
    t.string "address"
    t.string "description"
    t.boolean "has_delivery"
    t.integer "rating"
    t.float "latitude"
    t.float "longitude"
    t.boolean "is_active"
    t.boolean "has_venue"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "gender"
    t.integer "age"
    t.integer "profile"
    t.boolean "is_recurrent"
    t.float "search_radius"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "cuisines", "categories"
  add_foreign_key "cuisines", "restaurants"
  add_foreign_key "likes", "meals"
  add_foreign_key "likes", "users"
  add_foreign_key "meals", "restaurants"
  add_foreign_key "portions", "ingredients"
  add_foreign_key "portions", "meals"
end
