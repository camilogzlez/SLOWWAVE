class Category < ApplicationRecord
  has_many :category_photos
  validates :name, presence: true
end
