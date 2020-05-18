class CreateFanzaItems < ActiveRecord::Migration[6.0]
  def change
    create_table :fanza_items do |t|
      t.string :content_id
      t.jsonb :raw_json

      t.timestamps
    end
  end
end
