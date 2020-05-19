class AddDateToFanzaItems < ActiveRecord::Migration[6.0]
  def change
    add_column :fanza_items, :date, :datetime
  end
end
