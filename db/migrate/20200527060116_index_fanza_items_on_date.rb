class IndexFanzaItemsOnDate < ActiveRecord::Migration[6.0]
  def change
    add_index :fanza_items, :date
    add_index :fanza_items, [:normalized_id, :date]
  end
end
