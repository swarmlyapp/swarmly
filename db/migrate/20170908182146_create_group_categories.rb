class CreateGroupCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :group_categories do |t|
      t.integer :group_id
      t.integer :category_id
    end
  end
end
