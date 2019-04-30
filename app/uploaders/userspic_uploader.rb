class UserspicUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave
  include CarrierWave::MiniMagick
 
  version :picture_display do
    eager
    process resize_to_fill: [400, 400, "face:auto"]
  end
  
  def default_url
    "https://res.cloudinary.com/swarmly/image/upload/v1548239672/noprofile.png"
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_white_list
    %w(jpg jpeg gif png)
  end
end