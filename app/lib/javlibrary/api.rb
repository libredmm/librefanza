module Javlibrary
  class Api
    @@semaphore = Mutex.new

    def self.search(keyword)
      return to_enum(:search, keyword) unless block_given?

      @@semaphore.synchronize {
        @@client ||= Javlibrary::Client.new
        @@client.search(keyword) do |url, html|
          yield url, html
        end
      }
    rescue Selenium::WebDriver::Error::WebDriverError => e
      Rails.logger.error e
    end
  end
end
