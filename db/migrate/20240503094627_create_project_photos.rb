class CreateProjectPhotos < ActiveRecord::Migration[6.1]
  def change
    create_table :project_photos do |t|
      t.integer :position
      t.references :photo, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
