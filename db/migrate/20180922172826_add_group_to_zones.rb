class AddGroupToZones < ActiveRecord::Migration[5.2]
    def change
        add_column :zones, :group_id, :integer
    end
end