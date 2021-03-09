class CreateLinks < ActiveRecord::Migration[5.2]
    def change
      create_table :links do |t|
        t.belongs_to :user
        t.string :title, null: false
        t.string :url
        t.text :content
        t.timestamps     
      end
    end
end