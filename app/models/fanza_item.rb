class FanzaItem < ApplicationRecord
  include Derivable

  validates :content_id, presence: true, uniqueness: true
  validates :normalized_id, presence: true

  paginates_per 30

  def derive_fields
    self.content_id = self.as_struct.content_id
    self.normalized_id = self.as_struct.maker_product&.upcase || Fanza::Helper.normalize_id(self.content_id)

    self.date = DateTime.parse(self.as_struct.date)
  end

  def as_struct
    RecursiveOpenStruct.new(as_json, recurse_over_arrays: true)
  end

  def as_json
    raw_json.except("affiliateURL", "affiliateURLsp")
  end

  ###################
  # Items interface #
  ###################

  def title
    as_struct.title
  end

  def subtitle
    content_id
  end

  def cover_image_url
    as_struct.imageURL.large
  end

  def thumbnail_image_url
    as_struct.imageURL.small
  end

  def url
    as_struct.URL
  end

  # date

end
