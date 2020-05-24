class ReindexJavlibraryItems < ActiveRecord::Migration[6.0]
  def change
    add_index :javlibrary_items, :normalized_id
  end
end
