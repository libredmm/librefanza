class SodItem < ApplicationRecord
  include GenericItem

  belongs_to :sod_page

  validates :normalized_id, presence: true, uniqueness: true

  paginates_per 30

  def derive_fields
    html.css("table#v_introduction tr").each do |tr|
      ti = tr.at_css("td.v_intr_ti")&.text&.strip
      if ti&.start_with? "品番"
        self.normalized_id = Fanza::Id.normalize(tr.at_css("td.v_intr_tx").text.strip)
      elsif ti&.start_with? "出演者"
        self.actress_names = tr.css("td.v_intr_tx a").map(&:text).map(&:strip)
      end
    end

    self.actress_names ||= []
  end

  def html
    Nokogiri.HTML(sod_page.raw_html)
  end

  ###################
  # Items interface #
  ###################

  def title
    html.at_css("#videos_head h1:not([style*='none'])").text.strip
  end

  def subtitle
    ""
  end

  def cover_image_url
    html.at_css("div.videos_samimg > a")&.attr("href")&.strip
  end

  def thumbnail_image_url
    html.at_css("div.videos_samimg > a > img")&.attr("src")&.strip
  end

  def url
    sod_page.url
  end

  def date
    html.css("table#v_introduction tr").find { |tr|
      tr.at_css("td.v_intr_ti")&.text&.strip&.start_with? "発売年月日"
    }&.then { |tr|
      DateTime.parse(tr.at_css("td.v_intr_tx")&.text&.strip.gsub(/[年月日]/, '').gsub(/\s+/, '-'))
    }
  end

  def actresses
    actress_names.map { |name|
      FanzaActress.find_by(name: name) || FanzaActress.new(name: name)
    }
  end

  def description
    html.css("div.videos_textli > article").text
  end

  def genres
    html.css("table#v_introduction tr").find { |tr|
      tr.at_css("td.v_intr_ti")&.text&.strip&.start_with? "ジャンル"
    }&.css("td.v_intr_tx a")&.map(&:text)&.map(&:strip) || []
  end

  def review
    html.at_css("#review_toptd > div.imagestar > i")&.inner_text&.to_f
  end

  def labels
    html.css("table#v_introduction tr").find { |tr|
      tr.at_css("td.v_intr_ti")&.text&.strip&.start_with? "レーベル"
    }&.css("td.v_intr_tx")&.map(&:text)&.map(&:strip) || []
  end

  def makers
    html.css("table#v_introduction tr").find { |tr|
      tr.at_css("td.v_intr_ti")&.text&.strip&.start_with? "メーカー"
    }&.css("td.v_intr_tx a")&.map(&:text)&.map(&:strip) || []
  end

  def directors
    html.css("table#v_introduction tr").find { |tr|
      tr.at_css("td.v_intr_ti")&.text&.strip&.start_with? "監督"
    }&.css("td.v_intr_tx a")&.map(&:text)&.map(&:strip) || []
  end

  def volume
    html.css("table#v_introduction tr").find { |tr|
      tr.at_css("td.v_intr_ti")&.text&.strip&.start_with? "再生時間"
    }&.css("td.v_intr_tx")&.text&.to_i&.minutes
  end

  def logo_url
    "https://ec.sod.co.jp/prime/image/logo.png"
  end
end
