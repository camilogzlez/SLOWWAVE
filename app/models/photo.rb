class Photo < ApplicationRecord
  belongs_to :user
  has_one_attached :photo
  has_many :category_photos, dependent: :destroy
  has_many :categories, through: :category_photos
end
