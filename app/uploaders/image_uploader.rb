class ImageUploader < CarrierWave::Uploader::Base
    include Cloudinary::CarrierWave
    include CarrierWave::MiniMagick
   
    version :picture_display do
      eager
      process resize_to_fill: [700, 467, "face:auto"]
    end
  
    def default_url
      "https://res.cloudinary.com/swarmly/image/upload/v1548205122/noimage.png"
    end

    # Add a white list of extensions which are allowed to be uploaded.
    def extension_white_list
      %w(jpg jpeg gif png)
    end
  end