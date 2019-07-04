class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :confirmable,
  :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :google_oauth2]
  has_many :groups, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :active_saves, class_name: "Save", foreign_key: "saver_id", dependent: :destroy
  has_many :saving, through: :active_saves, source: :saved_note
  has_many :notifications, dependent: :destroy
  has_many :clips, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :zones, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :active_relationships,  class_name:  "Relationship",
                                   foreign_key: "follower_id",
                                   dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :likes
  has_many :group_relationships
  has_many :participated_groups, :through => :group_relationships, :source => :group
  
  mount_uploader :userspic, UserspicUploader


  validates :fullname,  presence: true, length: { maximum: 50}
  validates :username,  presence: true, length: { maximum: 20}, uniqueness: true
  #Username only allow letters,numbers and underscore
  validates :username, format: { with: /\A[\w\_]+\z/ }

  validates :email, presence: true, length: { maximum: 255 },
                                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  before_save do
    self.email.downcase! if self.email
  end
  extend FriendlyId
  friendly_id :username, use: [:slugged, :finders]

  def likes?(group)
    group.likes.where(user_id: id).any?
  end

  # Follows a user.
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Unfollows a user.
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end
  
  def follow_notification(user)
    Notification.notify_follow(user.id, self.id)
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end

  def saved(note)
    active_saves.create(saved_note_id: note.id)
  end

  #Removes a user from the save list for note
  def unsaved(note)
    active_saves.find_by(saved_note_id: note.id).destroy
  end

  #Returns true if the current user is saving the event
  def saving?(note)
    saving.include?(note)
  end
  
  def feed
    following_ids_subselect = "SELECT followed_id FROM relationships
                               WHERE  follower_id = :user_id"
    Group.where("user_id IN (#{following_ids_subselect})
                     OR user_id = :user_id", user_id: id)
  end

  def self.create_from_provider_data(provider_data)
    where(provider: provider_data.provider, uid: provider_data.uid).first_or_create do | user |
      user.email = provider_data.info.email
      user.fullname = provider_data.info.name
      user.username = "user#{provider_data.uid}"
      user.password = Devise.friendly_token[0, 20]
      user.remote_avatar = provider_data.info.image
      user.skip_confirmation!
    end
  end
  
  def self.find_for_authentication(conditions) 
    conditions[:email].downcase! 
    super(conditions) 
  end 
  
  def remember_me
    true
  end

  def userspic_size
    if userspic.size > 5.megabytes
        errors.add("Foto debe ser menor que 5MB")
    end
  end

  def join!(group)
    participated_groups << group
  end

  def quit!(group)
    participated_groups.delete(group)
  end
  
  def is_member_of?(group)
    participated_groups.include?(group)
  end
end
