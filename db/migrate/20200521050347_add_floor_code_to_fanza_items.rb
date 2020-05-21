class AddFloorCodeToFanzaItems < ActiveRecord::Migration[6.0]
  def change
    add_column :fanza_items, :floor_code, :string
    add_index :fanza_items, :floor_code
  end
end
