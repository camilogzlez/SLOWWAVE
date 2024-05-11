class AddPositionToCategoryPhoto < ActiveRecord::Migration[6.1]
  def change
    add_column :category_photos, :position, :integer
  end
end
