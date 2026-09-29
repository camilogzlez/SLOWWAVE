class CreateSubcategories < ActiveRecord::Migration[6.1]
  def change
    create_table :subcategories do |t|
      t.string :name, null: false
      t.references :category, null: false, foreign_key: true
      t.integer :position
      t.bigint :cover_photo_id

      t.timestamps
    end

    add_index :subcategories, :cover_photo_id
    add_foreign_key :subcategories, :photos, column: :cover_photo_id
  end
end
