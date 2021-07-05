class AddHealthAndLengthToCoordinates < ActiveRecord::Migration[6.1]
  def change
    add_column :coordinates, :health, :integer
    add_column :coordinates, :length, :integer
  end
end
