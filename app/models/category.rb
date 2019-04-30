class Category < ApplicationRecord
  has_many :group_categories
  mount_uploader :categoriespic, ImageUploader
  has_many :groups, through: :group_categories
  validate :categoriespic_size # validate calls a custom validation
  validates :name,
          presence: true,
          uniqueness: { case_sensitive: false },
          length: {minimum: 3, maximum: 25}
  private
  
  def categoriespic_size
  	if categoriespic.size > 5.megabytes
  		errors.add("Imagen debe ser menor que 5MB")
  	end
  end
  
end