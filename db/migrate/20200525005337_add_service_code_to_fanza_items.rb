class AddServiceCodeToFanzaItems < ActiveRecord::Migration[6.0]
  def change
    add_column :fanza_items, :service_code, :string
    add_index :fanza_items, :service_code
  end
end
