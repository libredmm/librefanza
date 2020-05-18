class AddNormalizedIdToFanzaItems < ActiveRecord::Migration[6.0]
  def change
    add_column :fanza_items, :normalized_id, :string
    FanzaItem.rebuild
  end
end
