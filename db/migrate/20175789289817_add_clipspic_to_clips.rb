class AddClipspicToClips < ActiveRecord::Migration[5.2]
    def change
      add_column :clips, :clipspic, :string
    end
  end
  