class Subcategory < ApplicationRecord
  belongs_to :category
  belongs_to :cover_photo, class_name: "Photo", optional: true

  has_many :category_photos, dependent: :destroy
  has_many :photos, through: :category_photos

  acts_as_list scope: :category

  validates :name, presence: true
end
