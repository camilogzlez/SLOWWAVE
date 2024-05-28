class ProjectPhoto < ApplicationRecord
  belongs_to :photo
  belongs_to :project

   delegate :thumbnail_url, to: :photo, prefix: true
end
