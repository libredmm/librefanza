class CreateFanzaActresses < ActiveRecord::Migration[6.0]
  def change
    create_table :fanza_actresses do |t|
      t.integer :fanza_id
      t.string :name
      t.jsonb :raw_json

      t.timestamps
    end
    add_index :fanza_actresses, :fanza_id, unique: true
  end
end
