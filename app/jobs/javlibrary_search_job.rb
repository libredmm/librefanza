class JavlibrarySearchJob < ApplicationJob
  queue_as :default

  def perform(*keywords)
    keywords.each do |keyword|
      @@client ||= Javlibrary::Client.new
      @@client.search(keyword).map { |url, raw_html|
        JavlibraryPage.create(url: url, raw_html: raw_html)
      }
    end
  end
end
