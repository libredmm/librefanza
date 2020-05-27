class AddActressesToJavlibraryItemsAndMgstageItems < ActiveRecord::Migration[6.0]
  def change
    add_column :javlibrary_items, :actress_names, :string, array: true
    add_index :javlibrary_items, :actress_names, using: :gin
    add_column :mgstage_items, :actress_names, :string, array: true
    add_index :mgstage_items, :actress_names, using: :gin
  end
end
