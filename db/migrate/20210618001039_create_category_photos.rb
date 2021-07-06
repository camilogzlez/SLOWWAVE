class CreateCategoryPhotos < ActiveRecord::Migration[6.1]
  def change
    create_table :category_photos do |t|
      t.references :photo, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
