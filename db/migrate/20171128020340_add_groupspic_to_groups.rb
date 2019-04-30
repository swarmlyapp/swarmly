class AddGroupspicToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :groupspic, :string
  end
end