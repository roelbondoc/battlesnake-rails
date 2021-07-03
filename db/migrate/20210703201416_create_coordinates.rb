class CreateCoordinates < ActiveRecord::Migration[6.1]
  def change
    create_table :coordinates do |t|
      t.integer :turn
      t.integer :max_x
      t.integer :max_y
      t.string :game_id

      t.integer :x
      t.integer :y

      t.string :snake_id
      t.string :content_type

      t.boolean :is_me

      t.timestamps
    end
  end
end
