class CreateFanzaActresses < ActiveRecord::Migration[6.0]
  def change
    create_table :fanza_actresses do |t|
      t.integer :id_fanza
      t.string :name
      t.jsonb :raw_json

      t.timestamps
    end
    add_index :fanza_actresses, :id_fanza, unique: true
  end
end
