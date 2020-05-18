class FanzaItem < ApplicationRecord
  validates :content_id, uniqueness: true

  def self.populate_from_fanza(keyword)
    Fanza::Api.item_list(keyword)["result"]["items"].map do |item|
      self.create(
        content_id: item["content_id"],
        raw_json: JSON.dump(item),
      )
    end
  end
end
