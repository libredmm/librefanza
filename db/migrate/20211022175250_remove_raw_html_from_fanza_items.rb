class RemoveRawHtmlFromFanzaItems < ActiveRecord::Migration[6.1]
  def change
    remove_column :fanza_items, :raw_html, :text
  end
end
