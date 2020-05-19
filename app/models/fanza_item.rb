class FanzaItem < ApplicationRecord
  validates :content_id, presence: true, uniqueness: true
  validates :normalized_id, presence: true

  before_validation :derive_fields
  after_touch :derive_fields

  def self.populate_from_fanza(keyword)
    Fanza::Api.item_list(keyword)["result"]["items"].map do |item|
      self.create(
        raw_json: item,
      )
    end
  end

  def safe_json
    raw_json.except("affiliateURL", "affiliateURLsp")
  end

  def json
    RecursiveOpenStruct.new(safe_json, recurse_over_arrays: true)
  end

  def derive_fields
    self.content_id = self.json.content_id
    self.normalized_id = Fanza::Helper.normalize_id(self.content_id)

    self.date = DateTime.parse(self.json.date)
  end
end
