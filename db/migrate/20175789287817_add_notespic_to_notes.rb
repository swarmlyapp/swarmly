class AddNotespicToNotes < ActiveRecord::Migration[5.2]
    def change
      add_column :notes, :notespic, :string
    end
  end