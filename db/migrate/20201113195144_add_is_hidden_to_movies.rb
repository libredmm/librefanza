class AddIsHiddenToMovies < ActiveRecord::Migration[6.0]
  def change
    add_column :movies, :is_hidden, :boolean, default: false, null: false
  end
end
