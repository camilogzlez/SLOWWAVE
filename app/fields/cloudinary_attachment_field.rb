# app/fields/cloudinary_attachment_field.rb
require "administrate/field/base"

class CloudinaryAttachmentField < Administrate::Field::Base
  def to_s
    data
  end

  def thumbnail
    if data.present?
      Cloudinary::Utils.cloudinary_url(data)
    else
      "no-image-available.png"
    end
  end
end
