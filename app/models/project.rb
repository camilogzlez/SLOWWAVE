class Project < ApplicationRecord
  has_many :project_photos
  validates :title, presence: true
end
