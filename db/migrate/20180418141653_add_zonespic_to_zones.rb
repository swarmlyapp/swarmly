class AddZonespicToZones < ActiveRecord::Migration[5.2]
    def change
        add_column :users, :zonespic, :string
    end
end