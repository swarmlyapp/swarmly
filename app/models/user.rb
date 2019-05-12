class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :confirmable,
  :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :google_oauth2]
  has_many :groups, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
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
  mount_uploader :userspic, UserspicUploader


  validates :fullname,  presence: true, length: { maximum: 50}
  validates :username,  presence: true, length: { maximum: 20}, uniqueness: true
  validates :username, format: { with:  /\A[a-zA-Z0-9]*\z/ }

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

  def favorite_for(group)
    favorites.where(group: group).first
  end

  def favorited_groups
    groups = []
    favorites.each do |favorite|
      groups << favorite.group
    end                                           
    groups
  end
  
  def feed
    following_ids_subselect = "SELECT followed_id FROM relationships
                               WHERE  follower_id = :user_id"
    Group.where("user_id IN (#{following_ids_subselect})
                     OR user_id = :user_id", user_id: id)
  end
  
  def self.create_from_facebook_data(facebook_data)
    where(provider: facebook_data.provider, uid: facebook_data.uid).first_or_create do | user |
      user.email =    facebook_data.info.email
      user.fullname = facebook_data.info.name
      user.username = "u/#{facebook_data.info.name.split.map{|i| i[0,3].downcase}.join}"
      user.password = Devise.friendly_token[0, 20]
      user.remote_avatar = facebook_data.info.image
      user.skip_confirmation!
    end
  end

  def self.create_from_google_data(google_data)
    where(provider: google_data.provider, uid: google_data.uid).first_or_create do | user |
      user.email =    google_data.info.email
      user.fullname = google_data.info.name
      user.username = "u/#{google_data.info.name.split.map{|i| i[0,3].downcase}.join}"
      user.password = Devise.friendly_token[0, 20]
      user.remote_avatar = google_data.info.image
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
end
