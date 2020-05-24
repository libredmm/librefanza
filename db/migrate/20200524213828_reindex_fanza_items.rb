class ReindexFanzaItems < ActiveRecord::Migration[6.0]
  def change
    remove_index :fanza_items, :normalized_id
    add_index :fanza_items, :normalized_id
    add_index :fanza_items, :content_id
  end
end
