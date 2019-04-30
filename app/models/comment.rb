class Comment < ApplicationRecord
  validates :description, presence: true
  belongs_to :group
  belongs_to :user
  delegate :userspic, to: :user, prefix: true  
  validates :user_id, presence: true
  validates :group_id, presence: true
  default_scope -> {order(updated_at: :desc)}   

  after_commit :create_notifications, on: :create

  after_create :add_mentions

  def add_mentions
    Mention.create_from_text(self)
  end

  private

  def create_notifications
    Notification.create do |notification|
      notification.notify_type = 'comment'
      notification.actor = self.user
      notification.user = self.group.user
      notification.target = self
      notification.second_target = self.group
    end
  end
end