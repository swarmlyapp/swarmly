class Link < ApplicationRecord
    belongs_to :user
    belongs_to :group
    validates :title, presence: true, length: { maximum: 250 }, allow_blank: false, allow_nil: false
  
    validate do
      if content.blank? && url.blank?
        errors.add(:error, "envia un enlace o contenido")
      end
      if content.present? && url.present?
        errors.add(:error, "envia un enlace o contenido pero no ambos.")
      end
    end
end