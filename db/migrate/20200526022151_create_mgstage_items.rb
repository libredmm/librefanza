class CreateMgstageItems < ActiveRecord::Migration[6.0]
  def change
    create_table :mgstage_items do |t|
      t.string :normalized_id
      t.references :mgstage_page, null: false, foreign_key: true

      t.timestamps
    end

    add_index :mgstage_items, :normalized_id, unique: true
  end
end
