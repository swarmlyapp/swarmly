class Vote < ApplicationRecord
    belongs_to :note
    belongs_to :user
    after_save :update_note
  
    validates :value, inclusion: {in: [-1, 1], message: "%{value} is not a valid vote."}, presence: true
  
    private

    def update_note
      note.update_rank  
    end
end