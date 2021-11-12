class AddPriorityToFanzaItem < ActiveRecord::Migration[6.1]
  def change
    add_column :fanza_items, :priority, :int, default: 0, null: false
    add_index :fanza_items, :priority
  end
end
