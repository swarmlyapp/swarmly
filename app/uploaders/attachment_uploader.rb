class AttachmentUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave
  include CarrierWave::MiniMagick
  
    def extension_white_list
      %w(pdf pptx doc htm html docx jpg jpeg gif png rar zip)
    end
  end
  