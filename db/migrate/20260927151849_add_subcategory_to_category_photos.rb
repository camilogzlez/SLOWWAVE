class AddSubcategoryToCategoryPhotos < ActiveRecord::Migration[6.1]
  def change
    add_reference :category_photos, :subcategory, foreign_key: true, null: true
  end
end
