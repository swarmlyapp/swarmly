class Comment < ApplicationRecord
  validates :description, presence: true
  belongs_to :group
  belongs_to :user
  delegate :userspic, to: :user, prefix: true  
  validates :user_id, presence: true
  validates :group_id, presence: true
  default_scope -> {order(updated_at: :desc)}   
  after_create :add_mentions

  def add_mentions
    Mention.create_from_text(self)
  end
end