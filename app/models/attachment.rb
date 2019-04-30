class Attachment < ApplicationRecord
	belongs_to :note
	mount_uploader :attachment, AttachmentUploader
end