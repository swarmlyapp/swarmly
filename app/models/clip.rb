class Clip < ApplicationRecord
    belongs_to :group
    belongs_to :user
    validates :caption, :group_id, presence: true 
    delegate :userspic, to: :user, prefix: true  
    mount_uploader :clipspic, ImageUploader
    validate :clipspic_size # validate calls a custom validation
    after_commit :create_notifications, on: :create

    private
      def clipspic_size
        if clipspic.size > 5.megabytes
          errors.add("Imagen debe ser menor que 5MB")
        end
      end

      def create_notifications
        Notification.create do |notification|
          notification.notify_type = 'clip'
          notification.actor = self.user
          notification.user = self.group.user
          notification.target = self
          notification.second_target = self.group
        end
      end
  end
  