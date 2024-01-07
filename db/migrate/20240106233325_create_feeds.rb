class CreateFeeds < ActiveRecord::Migration[7.1]
  def change
    create_table :feeds do |t|
      t.string :uri
      t.string :host
      t.text :content

      t.timestamps

      t.index :uri, unique: true
      t.index :host
    end
  end
end
