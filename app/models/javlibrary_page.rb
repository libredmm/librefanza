class JavlibraryPage < ApplicationRecord
  has_one :javlibrary_item, dependent: :destroy

  validates :url, presence: true, uniqueness: true
  validates :raw_html, presence: true

  after_save :parse_page
  after_touch :parse_page

  def self.populate_from_javlibrary(keyword)
    @@client ||= Javlibrary::Client.new
    @@client.search(keyword).map do |url, raw_html|
      create(url: url, raw_html: raw_html)
    end
  end

  def parse_page
    if self.javlibrary_item
      self.javlibrary_item.touch
    else
      self.create_javlibrary_item
    end
  end
end
