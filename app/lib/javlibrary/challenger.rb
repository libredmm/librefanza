require "webdrivers/chromedriver"

module Javlibrary
  class Challenger
    @@semaphore = Mutex.new

    def self.headers
      {
        "User-Agent" => self.user_agent,
        "Cookie" => "cf_clearance=#{self.cf_clearance}",
      }
    end

    private

    def self.user_agent
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36"
    end

    def self.cf_clearance
      @@semaphore.synchronize {
        Rails.cache.fetch("javlibrary_cf_clearance", expires_in: 1.hour) do
          Rails.logger.info "Refreshing cf clearance"
          Selenium::WebDriver::Chrome.path = ENV["GOOGLE_CHROME_SHIM"] if ENV["GOOGLE_CHROME_SHIM"].present?
          options = Selenium::WebDriver::Chrome::Options.new
          options.add_argument("headless")
          options.add_argument("user-agent=#{self.user_agent}")
          @driver = Selenium::WebDriver.for(:chrome, options: options)
          @driver.navigate.to "http://www.javlibrary.com/ja/"
          wait = Selenium::WebDriver::Wait.new(:timeout => 60)
          prompt = wait.until { @driver.find_element(css: "#adultwarningprompt input") }
          prompt.click

          @driver.manage.cookie_named("cf_clearance")[:value]
        end
      }
    end
  end
end
