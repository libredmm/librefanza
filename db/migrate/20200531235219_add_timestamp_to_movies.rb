class AddTimestampToMovies < ActiveRecord::Migration[6.0]
  def change
    add_timestamps :movies, null: true
    long_ago = DateTime.new(2020, 1, 1)
    Movie.update_all(created_at: long_ago, updated_at: long_ago)

    change_column_null :movies, :created_at, false
    change_column_null :movies, :updated_at, false
  end
end
