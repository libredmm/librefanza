class ReindexMovies < ActiveRecord::Migration[6.0]
  def change
    add_index :movies, [:normalized_id, :compressed_id], using: "gin", opclass: :gin_trgm_ops
  end
end
