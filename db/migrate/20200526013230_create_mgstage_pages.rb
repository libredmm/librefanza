class CreateMgstagePages < ActiveRecord::Migration[6.0]
  def change
    create_table :mgstage_pages do |t|
      t.string :url
      t.text :raw_html

      t.timestamps
    end

    add_index :mgstage_pages, :url, unique: true
    add_index :javlibrary_pages, :url, unique: true
  end
end
