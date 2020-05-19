class IndexJavlibraryItemsOnNormalizedId < ActiveRecord::Migration[6.0]
  def change
    add_index(
      :fanza_items,
      :normalized_id,
      using: "gin",
      opclass: :gin_trgm_ops,
    )
  end
end
