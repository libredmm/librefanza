class CreateJavlibraryItems < ActiveRecord::Migration[6.0]
  def change
    create_table :javlibrary_items do |t|
      t.string :normalized_id
      t.references :javlibrary_page, null: false, foreign_key: true

      t.timestamps
    end
  end
end
