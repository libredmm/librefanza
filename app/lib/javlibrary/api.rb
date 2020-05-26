module Javlibrary
  class Api
    def self.search(keyword)
      return to_enum(:search, keyword) unless block_given?

      client = Javlibrary::Client.new
      client.search(keyword) do |url, html|
        yield url, html
      end
    rescue Selenium::WebDriver::Error::WebDriverError => e
      Rails.logger.error e
    ensure
      client.quit if client
    end
  end
end
