class CreateSodPages < ActiveRecord::Migration[6.1]
  def change
    create_table :sod_pages do |t|
      t.string :url
      t.text :raw_html

      t.timestamps
    end

    add_index :sod_pages, :url, unique: true
  end
end
