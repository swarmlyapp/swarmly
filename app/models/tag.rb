class Tag < ApplicationRecord
    default_scope -> { order(name: :asc) }
    has_many :taggings, dependent: :destroy
    has_many :notes, through: :taggings
end