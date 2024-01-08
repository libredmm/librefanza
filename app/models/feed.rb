require "open-uri"

class Feed < ApplicationRecord
  validates :uri, presence: true, uniqueness: true
  validates :host, presence: true
  validates :content, presence: true

  before_validation :parse_host
  before_validation :fetch_content, on: :create

  validate :content_should_contain_at_least_one_item

  def content_should_contain_at_least_one_item
    if Nokogiri::XML(content).xpath("//channel/item").empty?
      errors.add(:content, "should contain at least one item")
    end
  end

  def parse_host
    self.host = URI.parse(uri).host
  end

  def fetch_content
    self.content = URI.parse(uri).read
  rescue OpenURI::HTTPError, WebMock::NetConnectNotAllowedError => e
    self.content = nil
    errors.add(:uri, e.message)
  end

  def refresh!
    fetch_content
    save!
  end

  def self.by_uri(uri)
    feed = find_or_create_by(uri: uri)
    feed.touch :accessed_at
    feed
  end
end
