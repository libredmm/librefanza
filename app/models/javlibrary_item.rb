class JavlibraryItem < ApplicationRecord
  include Derivable
  include GenericItem

  belongs_to :javlibrary_page

  validates :normalized_id, presence: true, uniqueness: true

  paginates_per 30

  def derive_fields
    self.normalized_id = Fanza::Id.normalize(html.at_css("#video_id td.text")&.text)
    self.actress_names = html.css(".cast .star").map(&:text).map(&:strip)
  end

  def html
    Nokogiri.HTML(javlibrary_page.raw_html)
  end

  ###################
  # Items interface #
  ###################

  def title
    html.at_css("#video_title > h3")&.text&.gsub(
      html.at_css("#video_id td.text")&.text, ""
    )&.strip
  end

  def subtitle
    URI.parse(url).query
  end

  def cover_image_url
    html.at_css("#video_jacket_img")&.attr("src")&.strip
  end

  def thumbnail_image_url
    cover_image_url.gsub(/pl\.jpg$/, "ps.jpg")
  end

  def url
    javlibrary_page.url
  end

  def date
    DateTime.parse(html.at_css("#video_date td.text")&.text&.strip)
  end

  def actresses
    actress_names.map do |name|
      FanzaActress.find_by(name: name) || FanzaActress.new(name: name)
    end
  end

  def description
    ""
  end

  def genres
    html.css("span.genre").map(&:text).map(&:strip) || []
  end

  def review
    html.at_css("span.score")&.text[/\d+(\.\d+)?/]&.to_f
  end

  def labels
    html.css("span.label").map(&:text).map(&:strip) || []
  end

  def makers
    html.css("span.maker").map(&:text).map(&:strip) || []
  end

  def directors
    html.css("span.director").map(&:text).map(&:strip) || []
  end
end
