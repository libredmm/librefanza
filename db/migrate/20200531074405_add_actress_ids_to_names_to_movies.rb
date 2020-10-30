class AddActressIdsToNamesToMovies < ActiveRecord::Migration[6.0]
  def change
    add_column :movies, :actress_fanza_ids, :integer, array: true
    add_index :movies, :actress_fanza_ids, using: :gin
    add_column :movies, :actress_names, :string, array: true
    add_index :movies, :actress_names, using: :gin
  end
end
