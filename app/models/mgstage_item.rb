class MgstageItem < ApplicationRecord
  include GenericItem

  belongs_to :mgstage_page

  validates :normalized_id, presence: true, uniqueness: true

  paginates_per 30

  def derive_fields
    html.css(".detail_data table tr").each do |tr|
      th = tr.at_css("th")&.text&.strip
      if th&.start_with? "品番"
        self.normalized_id = Fanza::Id.normalize(tr.at_css("td").text.strip)
      elsif th&.start_with? "出演"
        self.actress_names = tr.css("td a").map(&:text).map(&:strip)
      end
    end

    self.actress_names ||= []
  end

  def html
    Nokogiri.HTML(mgstage_page.raw_html)
  end

  ###################
  # Items interface #
  ###################

  def title
    html.at_css("h1.tag").text.strip
  end

  def subtitle
    url.split("/").reject(&:empty?).last
  end

  def cover_image_url
    html.at_css("#EnlargeImage")&.attr("href")&.strip
  end

  def thumbnail_image_url
    html.at_css(".enlarge_image")&.attr("src")&.strip
  end

  def url
    mgstage_page.url
  end

  def date
    html.css(".detail_data table tr").find { |tr|
      tr.at_css("th")&.text&.strip&.start_with? "配信開始日"
    }&.then { |tr|
      DateTime.parse(tr.at_css("td")&.text&.strip)
    }
  end

  def actresses
    actress_names.map { |name|
      FanzaActress.find_by(name: name) || FanzaActress.new(name: name)
    }
  end

  def description
    html.css("div.introduction").text
  end

  def genres
    html.css(".detail_data table tr").find { |tr|
      tr.at_css("th")&.text&.strip&.start_with? "ジャンル"
    }&.css("td a")&.map(&:text)&.map(&:strip) || []
  end

  def review
    html.at_css("td.review")&.inner_text&.to_f
  end

  def labels
    html.css(".detail_data table tr").find { |tr|
      tr.at_css("th")&.text&.strip&.start_with? "レーベル"
    }&.css("td a")&.map(&:text)&.map(&:strip) || []
  end

  def makers
    html.css(".detail_data table tr").find { |tr|
      tr.at_css("th")&.text&.strip&.start_with? "メーカー"
    }&.css("td a")&.map(&:text)&.map(&:strip) || []
  end

  def directors
    []
  end

  def volume
    html.css(".detail_data table tr").find { |tr|
      tr.at_css("th")&.text&.strip&.start_with? "収録時間"
    }&.css("td")&.text&.to_i&.minutes
  end

  def logo_url
    "https://static.mgstage.com/mgs/img/pc/top_logo.jpg"
  end

  def sample_image_urls
    []
  end
end
