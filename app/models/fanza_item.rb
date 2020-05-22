class FanzaItem < ApplicationRecord
  include Derivable

  validates :content_id, presence: true, uniqueness: true
  validates :normalized_id, presence: true
  validates :floor_code, inclusion: { in: %w[dvd rental_dvd video videoa videoc] }

  paginates_per 30

  def derive_fields
    self.content_id = self.as_struct.content_id
    self.normalized_id = Fanza::Helper.normalize_id(self.as_struct.maker_product || self.content_id)

    self.date = DateTime.parse(self.as_struct.date)
    self.floor_code = self.as_struct.floor_code
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

  def actresses
    as_struct.iteminfo.actress.map do |info|
      FanzaActress.find_by(id_fanza: info.id) || OpenStruct.new(name: info.name)
    end
  end
end
