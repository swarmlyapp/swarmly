class CreateAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :attachments do |t|
      t.integer :note_id
      t.string :attachment
      t.timestamps
    end
  end
end