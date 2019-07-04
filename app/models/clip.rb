class Clip < ApplicationRecord
    belongs_to :group
    belongs_to :user
    validates :caption, :group_id, presence: true 
    delegate :userspic, to: :user, prefix: true  
    has_many :attachments, :dependent => :destroy
    accepts_nested_attributes_for :attachments, allow_destroy: true
    after_commit :create_notifications, on: :create

    private

      def create_notifications
        Notification.create do |notification|
          notification.notify_type = 'clip'
          notification.actor = self.user
          notification.user = self.group.member.first
          notification.target = self
          notification.second_target = self.group
        end
      end
  end