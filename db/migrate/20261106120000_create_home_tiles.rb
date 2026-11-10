class CreateHomeTiles < ActiveRecord::Migration[6.1]
  def change
    create_table :home_tiles do |t|
      t.references :photo, null: false, foreign_key: true, index: { unique: true }
      t.integer :position
      t.integer :column_span, null: false, default: 3
      t.integer :row_span, null: false, default: 3

      t.timestamps
    end
  end
end
