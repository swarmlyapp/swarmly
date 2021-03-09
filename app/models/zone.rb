class Zone < ApplicationRecord
    belongs_to :group
    belongs_to :user
    mount_uploader :zonespic, ImageUploader
    delegate :userspic, to: :user, prefix: true 
    geocoded_by :address
    after_validation :geocode
    validate :zonespic_size # validate calls a custom validation
    validates :name, presence: true, length: { minimum: 5, maximum: 100 }
	  validates :day , :hour, :address, :group_id, presence: true 
    #after_commit :create_notifications, on: :create

    private
    def zonespic_size
        if zonespic.size > 5.megabytes
            errors.add("Imagen debe ser menor que 5MB")
        end
    end
    
    def create_notifications
      Notification.create do |notification|
        notification.notify_type = 'zone'
        notification.actor = self.user
        notification.user = self.group.user
        notification.target = self
        notification.second_target = self.group
      end
    end
end
  