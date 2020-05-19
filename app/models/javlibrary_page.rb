class JavlibraryPage < ApplicationRecord
  validates :url, presence: true, uniqueness: true
  validates :raw_html, presence: true

  def self.populate_from_javlibrary(keyword)
    @@client ||= Javlibrary::Client.new
    @@client.search(keyword).map do |url, raw_html|
      create(url: url, raw_html: raw_html)
    end
  end
end
