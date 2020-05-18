class FanzaItem < ApplicationRecord
  validates :content_id, presence: true, uniqueness: true
  validates :normalize_id, presence: true
  before_validation :normalize_id

  def self.populate_from_fanza(keyword)
    Fanza::Api.item_list(keyword)["result"]["items"].map do |item|
      self.create(
        content_id: item["content_id"],
        raw_json: JSON.dump(item),
      )
    end
  end

  def self.rebuild
    self.find_each do |item|
      item.normalize_id
      item.save
    end
  end

  def normalize_id
    self.normalized_id = Fanza::Helper.normalize_id(self.content_id)
  end
end
