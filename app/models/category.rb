class Category < ApplicationRecord
  has_many :category_photos
  has_many :subcategories, -> { order(:position) }, dependent: :destroy
  validates :name, presence: true
end
