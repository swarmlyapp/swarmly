class Group < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :clips, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :zones, dependent: :destroy
  has_many :group_categories
  has_many :favorites, dependent: :destroy
  mount_uploader :groupspic, ImageUploader
  delegate :userspic, to: :user, prefix: true  
  has_many :categories, through: :group_categories
  validates :name, presence: true, length: { minimum: 5, maximum: 100 }
  validates :user_id, presence: true
  validate :groupspic_size # validate calls a custom validation

  private
  
  	def groupspic_size
  		if groupspic.size > 5.megabytes
  			errors.add("Imagen debe ser menor que 5MB")
  		end
  	end
  	
end