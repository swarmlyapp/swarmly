class Clip < ApplicationRecord
    belongs_to :group
    belongs_to :user
    validates :caption, :group_id, presence: true 
    delegate :userspic, to: :user, prefix: true  
    has_many :attachments, :dependent => :destroy
    accepts_nested_attributes_for :attachments, allow_destroy: true
end