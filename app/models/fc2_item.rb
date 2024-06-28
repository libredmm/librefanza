class Fc2Item < ApplicationRecord
  include GenericItem

  belongs_to :fc2_page

  validates :normalized_id, presence: true, uniqueness: true, format: { with: /\AFC2-\d+\z/ }

  paginates_per 30

  def derive_fields
    self.normalized_id = "FC2-" + fc2_page.url.split("/").last
    self.actress_names = []
  end

  def html
    Nokogiri.HTML(fc2_page.raw_html)
  end

  ###################
  # Items interface #
  ###################

  def title
    html.at_css(".items_article_headerInfo > h3").text.strip
  end

  def subtitle
    ""
  end

  def cover_image_url
    html.at_css(".items_article_SampleImages li a")&.attr("href")&.strip
  end

  def thumbnail_image_url
    html.at_css(".items_article_MainitemThumb img")&.attr("src")&.strip
  end

  def url
    fc2_page.url
  end

  def date
    DateTime.parse(html.at_css("div.items_article_Releasedate"))
  rescue TypeError
    nil
  end

  def actresses
    []
  end

  def description
    html.css(".items_article_Contents iframe").text
  end

  def genres
    []
  end

  def review
    0
  end

  def labels
    html.css(".items_article_TagArea a.tag")&.map(&:text)&.map(&:strip) || []
  end

  def makers
    []
  end

  def directors
    []
  end

  def volume
    nil
  end

  def logo_url
    "https://static.fc2.com/contents/images/header/main_logo_new.png"
  end
end
