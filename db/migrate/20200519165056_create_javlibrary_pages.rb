class CreateJavlibraryPages < ActiveRecord::Migration[6.0]
  def change
    create_table :javlibrary_pages do |t|
      t.string :url
      t.text :raw_html

      t.timestamps
    end
  end
end
