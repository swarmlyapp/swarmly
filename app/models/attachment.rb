class Attachment < ApplicationRecord
	belongs_to :clip
	mount_uploader :attachment, AttachmentUploader
end