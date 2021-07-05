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

ActiveRecord::Schema.define(version: 2021_07_05_193112) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "coordinates", force: :cascade do |t|
    t.integer "turn"
    t.integer "max_x"
    t.integer "max_y"
    t.string "game_id"
    t.integer "x"
    t.integer "y"
    t.integer "distance"
    t.string "snake_id"
    t.string "content_type"
    t.boolean "is_me"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "health"
    t.integer "length"
    t.index ["game_id", "turn", "x", "y", "content_type"], name: "by_gid_t_x_y_ct"
    t.index ["game_id", "turn", "x", "y"], name: "index_coordinates_on_game_id_and_turn_and_x_and_y"
    t.index ["game_id", "turn"], name: "index_coordinates_on_game_id_and_turn"
  end

end
