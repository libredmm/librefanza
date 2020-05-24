class IndexFanzaActressOnName < ActiveRecord::Migration[6.0]
  def change
    add_index :fanza_actresses, :name
  end
end
