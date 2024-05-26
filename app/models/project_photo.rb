class ProjectPhoto < ApplicationRecord
  belongs_to :photo
  belongs_to :project

  delegate :photo, to: :photo, prefix: true

  def photo_url
    Rails.application.routes.url_helpers.rails_blob_url(photo_photo, only_path: true) if photo_photo.attached?
  end
end
