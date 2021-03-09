class CreateSaves < ActiveRecord::Migration[5.2]
    def change
      create_table :saves do |t|
        t.integer :saver_id
        t.integer :saved_note_id
  
        t.timestamps null: false
      end
      add_index :saves, :saver_id
      add_index :saves, :saved_note_id
      add_index :saves, [:saver_id, :saved_note_id], unique: true
    end
end
  