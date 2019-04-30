class AddGroupToClips < ActiveRecord::Migration[5.2]
    def change
      add_column :clips, :group_id, :integer
    end
  end
  