class AddGroupToLinks < ActiveRecord::Migration[5.2]
    def change
        add_column :links, :group_id, :integer
    end
end