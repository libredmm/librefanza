class FanzaItem < ApplicationRecord
  include Derivable
  include GenericItem

  validates :raw_json, presence: true
  validates :content_id, presence: true, uniqueness: true
  validates :normalized_id, presence: true
  validates :floor_code, inclusion: { in: %w[dvd video videoa videoc] }
  validates :service_code, inclusion: { in: %w[digital mono] }

  after_save :fetch_html!

  paginates_per 30

  def derive_fields
    self.content_id = self.as_struct.content_id.strip
    self.normalized_id = Fanza::Id.normalize(self.content_id)
    if self.as_struct.maker_product && self.normalized_id == self.content_id
      self.normalized_id = Fanza::Id.normalize(self.as_struct.maker_product)
    end

    self.date = DateTime.parse(self.as_struct.date)
    self.floor_code = self.as_struct.floor_code.strip
    self.service_code = self.as_struct.service_code.strip
  end

  def fetch_html!
    if self.raw_html.blank?
      html = Faraday.new { |conn|
        conn.use FaradayMiddleware::FollowRedirects
        conn.response :encoding
        conn.adapter Faraday.default_adapter
      }.get(self.url).body.encode("UTF-8", invalid: :replace, undef: :replace).gsub("\u0000", "")
      self.update_column(:raw_html, html)
    end
  end

  def as_struct
    RecursiveOpenStruct.new(safe_json, recurse_over_arrays: true)
  end

  def safe_json
    raw_json.except("affiliateURL", "affiliateURLsp")
  end

  def html
    Nokogiri::HTML(self.raw_html)
  end

  ###################
  # Items interface #
  ###################

  def title
    as_struct.title.strip
  end

  def subtitle
    content_id
  end

  def cover_image_url
    as_struct.imageURL&.large
  end

  def thumbnail_image_url
    as_struct.imageURL&.small
  end

  def url
    as_struct.URL
  end

  def actresses
    as_struct.iteminfo&.actress&.map { |info|
      FanzaActress.find_by(fanza_id: info.id) || FanzaActress.new(name: info.name&.strip)
    } || []
  end

  def description
    html.css(".mg-b20.lh4")&.text&.strip
  end

  def genres
    as_struct.iteminfo&.genre&.map(&:name)&.map(&:strip) || []
  end

  def review
    (as_struct.review&.average&.to_f || 0) * 2.0
  end

  def labels
    as_struct.iteminfo&.label&.map(&:name)&.map(&:strip) || []
  end

  def makers
    as_struct.iteminfo&.maker&.map(&:name)&.map(&:strip) || []
  end

  def directors
    as_struct.iteminfo&.director&.map(&:name)&.map(&:strip) || []
  end
end
