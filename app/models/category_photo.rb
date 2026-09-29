class CategoryPhoto < ApplicationRecord
  belongs_to :photo
  belongs_to :category
  belongs_to :subcategory, optional: true

  acts_as_list scope: %i[category_id subcategory_id]

  validate :subcategory_belongs_to_category

  private

  def subcategory_belongs_to_category
    return if subcategory.blank?

    errors.add(:subcategory, "must belong to the same category") if subcategory.category_id != category_id
  end
end
