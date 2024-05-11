class ProjectPhoto < ApplicationRecord
  belongs_to :photo
  belongs_to :project
end
