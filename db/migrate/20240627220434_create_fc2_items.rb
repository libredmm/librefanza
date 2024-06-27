class CreateFc2Items < ActiveRecord::Migration[7.1]
  def change
    create_table :fc2_items do |t|
      t.string :normalized_id
      t.references :fc2_page, null: false, foreign_key: true
      t.string :actress_names, array: true

      t.timestamps
    end
    add_index :fc2_items, :actress_names, using: :gin
  end
end
