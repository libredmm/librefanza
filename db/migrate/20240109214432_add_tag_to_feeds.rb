class AddTagToFeeds < ActiveRecord::Migration[7.1]
  def change
    add_column :feeds, :tag, :string
  end
end
