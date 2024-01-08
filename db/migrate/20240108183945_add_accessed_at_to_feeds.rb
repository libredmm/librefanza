class AddAccessedAtToFeeds < ActiveRecord::Migration[7.1]
  def change
    add_column :feeds, :accessed_at, :datetime, null: false, default: -> { 'NOW()' }
  end
end
