class AddDescriptionToFanzaItems < ActiveRecord::Migration[6.1]
  def change
    add_column :fanza_items, :description, :text
  end
end
