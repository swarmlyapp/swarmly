class Note < ApplicationRecord
	belongs_to :group
	belongs_to :user
  has_many :passive_saves, class_name: "Save", foreign_key: "saved_note_id", dependent: :destroy
  has_many :savers, through: :passive_saves, source: :saver
	has_many :taggings, dependent: :destroy
	has_many :tags, through: :taggings
	has_many :votes, dependent: :destroy
	after_create :create_vote
	validates :name, presence: true, length: { maximum: 80 }
	validates :body , :group_id, presence: true 
	mount_uploader :notespic, NotespicUploader
  delegate :userspic, to: :user, prefix: true  
	validates :tag_list, length: {maximum: 230}
  #after_commit :create_notifications, on: :create
	default_scope {order('rank DESC')}

	def tag_list=(tags_string)
		tag_names = tags_string.split(",").collect{|s| s.strip.downcase}.uniq
		new_or_found_tags = tag_names.collect { |name| Tag.find_or_create_by(name: name) }
  		self.tags = new_or_found_tags
	end

	def tag_list
		self.tags.collect do |tag|
			tag.name
		end.join(",")
	end

	def up_votes
		votes.where(value: 1).count
	end
	
	def down_votes
		votes.where(value: -1).count
	end
	
	def points
		votes.sum(:value)
	end
	
	def update_rank
		age_in_days = (created_at - Time.new(1970,1,1)) / 1.day.seconds
		new_rank = points + age_in_days
		update_attribute(:rank, new_rank)
	end
	
	private
	
	def create_vote
		user.votes.create(value: 1, note: self)
	end

  def notespic_size
    if notespic.size > 5.megabytes
        errors.add("Imagen debe ser menor que 5MB")
    end
	end
	
	# def create_notifications
    # Notification.create do |notification|
    #   notification.notify_type = 'note'
    #   notification.actor = self.user
    #   notification.user = self.group.user
    #   notification.target = self
    #   notification.second_target = self.group
    # end
	#end
end