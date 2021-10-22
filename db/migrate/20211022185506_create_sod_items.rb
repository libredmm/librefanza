class CreateSodItems < ActiveRecord::Migration[6.1]
  def change
    create_table :sod_items do |t|
      t.string :normalized_id
      t.references :sod_page, null: false, foreign_key: true
      t.string :actress_names, array: true

      t.timestamps
    end

    add_index :sod_items, :actress_names, using: :gin
  end
end
