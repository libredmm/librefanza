class FanzaItem < ApplicationRecord
  include GenericItem

  validates :raw_json, presence: true
  validates :content_id, presence: true, uniqueness: true
  validates :normalized_id, presence: true
  validates :floor_code, inclusion: { in: %w[dvd nikkatsu video videoa videoc] }
  validates :service_code, inclusion: { in: %w[digital mono] }

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

    if self.description.blank?
      begin
        raw_html = Faraday.new { |conn|
          conn.use FaradayMiddleware::FollowRedirects
          conn.response :encoding
          conn.adapter Faraday.default_adapter
        }.get(self.url) { |req|
          req.headers = {
            "Cookie" => "age_check_done=1",
          }
        }.body.encode("UTF-8", invalid: :replace, undef: :replace).gsub("\u0000", "")

        self.description = Nokogiri::HTML(raw_html).css(".mg-b20.lh4")&.text&.strip
      rescue Exception
      end
    end
  end

  def as_struct
    RecursiveOpenStruct.new(safe_json, recurse_over_arrays: true)
  end

  def safe_json
    raw_json.except("affiliateURL", "affiliateURLsp")
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

  def volume
    as_struct.volume&.to_i&.minutes
  end

  def logo_url
    "https://p.dmm.co.jp/p/affiliate/web_service/r18_88_35.gif"
  end

  def sample_image_urls
    as_struct.sampleImageURL&.sample_l&.image ||
    as_struct.sampleImageURL&.sample_m&.image ||
    as_struct.sampleImageURL&.sample_s&.image ||
    []
  end
end
