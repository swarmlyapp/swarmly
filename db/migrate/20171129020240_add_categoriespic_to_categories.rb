class AddCategoriespicToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :categoriespic, :string
  end
end