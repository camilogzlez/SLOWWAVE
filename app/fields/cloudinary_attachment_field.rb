# app/fields/cloudinary_attachment_field.rb
require "administrate/field/base"

class CloudinaryAttachmentField < Administrate::Field::Base
  def to_s
    data
  end

  def thumbnail
    # Assuming `data` is the URL to the Cloudinary image
    return unless data.present?

    # You can adjust the size of the image thumbnail here
    image_tag(data, width: 100, height: 100)
  end
end
