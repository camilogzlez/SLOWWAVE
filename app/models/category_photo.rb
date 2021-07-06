class CategoryPhoto < ApplicationRecord
  belongs_to :photo
  belongs_to :category
end
