class CreateNotes < ActiveRecord::Migration[5.2]
    def change
      create_table :notes do |t|
        t.string :name
        t.belongs_to :user
        t.string :body
        t.timestamps
      end
    end
  end