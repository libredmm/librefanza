class IndexFanzaItemOnRawJson < ActiveRecord::Migration[6.0]
  def change
    add_index(
      :fanza_items,
      :raw_json,
      using: "gin",
      opclass: :jsonb_path_ops,
    )
  end
end
