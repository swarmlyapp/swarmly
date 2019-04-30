class CreateZones < ActiveRecord::Migration[5.2]
  def change
    create_table :zones do |t|
      t.string :name
      t.string :day
      t.string :hour
      t.string :price
      t.string :address
      t.belongs_to :user

      t.timestamps
    end
  end
end
