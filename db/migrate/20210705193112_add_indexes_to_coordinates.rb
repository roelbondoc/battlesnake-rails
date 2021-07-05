class AddIndexesToCoordinates < ActiveRecord::Migration[6.1]
  def change
    add_index :coordinates, %i[game_id turn]
    add_index :coordinates, %i[game_id turn x y]
    add_index :coordinates, %i[game_id turn x y content_type], name: 'by_gid_t_x_y_ct'
  end
end
