class ProjectPhoto < ApplicationRecord
  belongs_to :photo
  belongs_to :project
  acts_as_list

   delegate :thumbnail_url, to: :photo, prefix: true
end
