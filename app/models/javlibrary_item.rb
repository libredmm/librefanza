class JavlibraryItem < ApplicationRecord
  include Derivable

  belongs_to :javlibrary_page

  validates :normalized_id, presence: true, uniqueness: true

  paginates_per 30

  def derive_fields
    self.normalized_id = html.at_css("#video_id td.text")&.content
  end

  def html
    Nokogiri.HTML(javlibrary_page.raw_html)
  end

  ###################
  # Items interface #
  ###################

  def title
    html.at_css("#video_title > h3")&.content&.gsub(normalized_id, "").strip
  end

  def subtitle
    URI.parse(url).query
  end

  def cover_image_url
    html.at_css("#video_jacket_img")&.attr("src")
  end

  def thumbnail_image_url
    cover_image_url.gsub(/pl\.jpg$/, "ps.jpg")
  end

  def url
    javlibrary_page.url
  end

  def date
    DateTime.parse(html.at_css("#video_date td.text")&.content)
  end

  def actresses
    html.css(".cast .star").map do |span|
      name = span.content.strip
      FanzaActress.find_by(name: span.content.strip) || OpenStruct.new(name: name)
    end
  end

  def description
    ""
  end

  def genres
    html.css("span.genre").map(&:text) || []
  end

  def review
    html.at_css("span.score")&.text[/\d+(\.\d+)?/]&.to_f
  end

  def labels
    html.css("span.label").map(&:text) || []
  end
end
