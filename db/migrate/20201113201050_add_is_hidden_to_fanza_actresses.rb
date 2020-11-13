class AddIsHiddenToFanzaActresses < ActiveRecord::Migration[6.0]
  def change
    add_column :fanza_actresses, :is_hidden, :boolean, default: false, null: false
  end
end
