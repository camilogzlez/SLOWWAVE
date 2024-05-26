class Project < ApplicationRecord
  has_many :project_photos
  has_many :photos, through: :project_photos
  validates :title, presence: true
end
