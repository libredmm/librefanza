class AddRawHtmlToFanzaItems < ActiveRecord::Migration[6.0]
  def change
    add_column :fanza_items, :raw_html, :text
  end
end
