class ReindexFanzaActresses < ActiveRecord::Migration[6.0]
  def change
    add_index :fanza_actresses, :name, using: "gin", opclass: :gin_trgm_ops, name: "fuzzy_name"
    add_index :fanza_actresses, :raw_json, using: "gin", opclass: :jsonb_path_ops
  end
end
