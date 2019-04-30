class AddLatitudeAndLongitudeToZone < ActiveRecord::Migration[5.2]
  def change
    add_column :zones, :latitude, :float
    add_column :zones, :longitude, :float
  end
end
