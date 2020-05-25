class FanzaItem < ApplicationRecord
  include Derivable
  include GenericItem

  validates :raw_json, presence: true
  validates :raw_html, presence: true
  validates :content_id, presence: true, uniqueness: true
  validates :normalized_id, presence: true
  validates :floor_code, inclusion: { in: %w[dvd video videoa videoc] }
  validates :service_code, inclusion: { in: %w[digital mono] }

  paginates_per 30

  def derive_fields
    self.content_id = self.as_struct.content_id
    self.normalized_id = Fanza::Helper.normalize_id(self.content_id)
    if self.as_struct.maker_product && self.normalized_id == self.content_id
      self.normalized_id = Fanza::Helper.normalize_id(self.as_struct.maker_product)
    end

    self.date = DateTime.parse(self.as_struct.date)
    self.floor_code = self.as_struct.floor_code
    self.service_code = self.as_struct.service_code
    self.raw_html ||= HTTParty.get(self.url).body
  end

  def as_struct
    RecursiveOpenStruct.new(raw_json, recurse_over_arrays: true)
  end

  def html
    Nokogiri::HTML(self.raw_html)
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
    as_struct.iteminfo.actress&.map { |info|
      FanzaActress.find_by(id_fanza: info.id) || OpenStruct.new(name: info.name)
    } || []
  end

  def description
    html.css(".mg-b20.lh4")&.text.strip
  end

  def genres
    as_struct.iteminfo.genre&.map(&:name) || []
  end

  def review
    as_struct.review&.average
  end

  def labels
    as_struct.iteminfo.label&.map(&:name) || []
  end

  def makers
    as_struct.iteminfo.maker&.map(&:name) || []
  end

  def directors
    as_struct.iteminfo.director&.map(&:name) || []
  end
end
