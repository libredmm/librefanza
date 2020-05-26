class MgstageItem < ApplicationRecord
  include Derivable
  include GenericItem

  belongs_to :mgstage_page

  validates :normalized_id, presence: true, uniqueness: true

  paginates_per 30

  def derive_fields
    html.css(".detail_data table tr").each do |tr|
      if tr.at_css("th")&.text&.strip&.start_with? "品番"
        self.normalized_id = Fanza::Id.normalize(tr.at_css("td").text.strip)
      end
    end
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
    html.css(".detail_data table tr").each do |tr|
      if tr.at_css("th")&.text&.strip&.start_with? "配信開始日"
        return DateTime.parse(tr.at_css("td")&.text&.strip)
      end
    end
    nil
  end

  def actresses
    html.css(".detail_data table tr").each do |tr|
      if tr.at_css("th")&.text&.strip&.start_with? "出演"
        return tr.css("td a").map { |a|
                 name = a.text.strip
                 FanzaActress.find_by(name: name) || FanzaActress.new(name: name)
               }
      end
    end
    []
  end

  def description
    html.css("div.introduction").text
  end

  def genres
    html.css(".detail_data table tr").each do |tr|
      if tr.at_css("th")&.text&.strip&.start_with? "ジャンル"
        return tr.css("td a").map(&:text).map(&:strip)
      end
    end
    []
  end

  def review
    html.at_css("td.review")&.inner_text&.to_f
  end

  def labels
    html.css(".detail_data table tr").each do |tr|
      if tr.at_css("th")&.text&.strip&.start_with? "レーベル"
        return tr.css("td a").map(&:text).map(&:strip)
      end
    end
    []
  end

  def makers
    html.css(".detail_data table tr").each do |tr|
      if tr.at_css("th")&.text&.strip&.start_with? "メーカー"
        return tr.css("td a").map(&:text).map(&:strip)
      end
    end
    []
  end

  def directors
    []
  end
end
