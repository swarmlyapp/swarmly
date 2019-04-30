class AddGroupToNotes < ActiveRecord::Migration[5.2]
    def change
      add_column :notes, :group_id, :integer
    end
  end