class AddRankToNotes < ActiveRecord::Migration[5.2]
    def change
      add_column :notes, :rank, :float
    end
  end
  