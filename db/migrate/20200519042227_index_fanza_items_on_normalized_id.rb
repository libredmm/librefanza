class IndexFanzaItemsOnNormalizedId < ActiveRecord::Migration[6.0]
  def change
    enable_extension "pg_trgm"
    add_index(
      :fanza_items,
      [:normalized_id, :content_id],
      using: "gin",
      opclass: :gin_trgm_ops,
    )
  end
end
