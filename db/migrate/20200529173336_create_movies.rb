class CreateMovies < ActiveRecord::Migration[6.0]
  def change
    create_table :movies do |t|
      t.string :normalized_id, null: false
      t.string :compressed_id, null: false
      t.datetime :date
    end

    add_index :movies, :normalized_id, unique: true
    add_index :movies, :compressed_id
    add_index :movies, :date
    add_index :movies, [:date, :normalized_id]
  end
end
