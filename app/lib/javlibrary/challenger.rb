require "webdrivers/chromedriver"

module Javlibrary
  class Challenger
    @@semaphore = Mutex.new

    def self.headers
      {
        "User-Agent" => self.user_agent,
        "Cookie" => "cf_clearance=#{self.cf_clearance}; over18=18",
      }
    end

    private

    def self.user_agent
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.61 Safari/537.36"
    end

    def self.cf_clearance
      @@semaphore.synchronize {
        Rails.cache.fetch("javlibrary_cf_clearance", expires_in: 1.hour) do
          Rails.logger.info "Refreshing cf clearance"
          Selenium::WebDriver::Chrome.path = ENV["GOOGLE_CHROME_SHIM"] if ENV["GOOGLE_CHROME_SHIM"].present?
          options = Selenium::WebDriver::Chrome::Options.new
          # options.headless!
          options.add_argument("user-agent=#{self.user_agent}")
          options.add_argument("remote-debugging-port=9222")
          options.add_argument("disable-blink-features=AutomationControlled")
          driver = Selenium::WebDriver.for(:chrome, options: options)
          driver.navigate.to "http://www.javlibrary.com/ja/"
          sleep(10)
          sleeped = 10
          while true
            begin
              return driver.manage.cookie_named("cf_clearance")[:value]
            rescue Selenium::WebDriver::Error::NoSuchCookieError
              raise if sleeped >= 30
              Rails.logger.debug "Waiting for browser to auto redirect"
              sleep(5)
              sleeped += 5
            end
          end
        ensure
          driver.quit if driver
        end
      }
    end
  end
end
