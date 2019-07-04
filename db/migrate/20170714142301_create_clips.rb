class CreateClips < ActiveRecord::Migration[5.2]
    def change
      create_table :clips do |t|
        t.belongs_to :user
        t.string :caption
        t.timestamps     
      end
    end
end
  