class CreateFc2Pages < ActiveRecord::Migration[7.1]
  def change
    create_table :fc2_pages do |t|
      t.string :url
      t.text :raw_html

      t.timestamps
    end
    add_index :fc2_pages, :url
  end
end
