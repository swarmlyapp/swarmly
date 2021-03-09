class Save < ApplicationRecord
    belongs_to :saver, class_name: "User"
    belongs_to :saved_note, class_name: "Note"
    validates :saver_id, presence: true
    validates :saved_note_id, presence: true
end
  