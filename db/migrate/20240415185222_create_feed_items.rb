class CreateFeedItems < ActiveRecord::Migration[7.1]
  def change
    create_table :feed_items do |t|
      t.string :guid
      t.text :content

      t.timestamps
    end
    add_index :feed_items, :guid, unique: true
  end
end
