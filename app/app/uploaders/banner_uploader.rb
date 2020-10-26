class BannerUploader < AttachmentUploader
  include CarrierWave::MiniMagick

  def filename
    if original_filename.present?
      "#{secure_token}.#{file.extension}"
    end
  end
  
  # Process files as they are uploaded:
  process quality: 60
  process resize_and_crop: [1280,400]
  
  def extension_white_list
    %w(jpg jpeg gif png)
  end

private
  # Resize and crop banner from middle of image
  def resize_and_crop(width, height)  
    manipulate! do |image|  
      new_height = (width/image[:width] * image[:height]).round
      image.resize("#{width}x#{new_height}")
      if new_height > height
        remove = ((new_height - height)/2).round 
        image.shave("0x#{remove}") 
      end
      image
    end
  end
end
