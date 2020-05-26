require "webdrivers/chromedriver"

module Javlibrary
  class Client
    def initialize
      initialize_driver
    end

    def initialize_driver
      Selenium::WebDriver::Chrome.path = ENV["GOOGLE_CHROME_SHIM"] if ENV["GOOGLE_CHROME_SHIM"].present?
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument("headless")
      user_agent = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.50 Safari/537.36"
      options.add_argument("user-agent='#{user_agent}'")
      port = 30000 + rand(30000)
      options.add_argument("remote-debugging-port=#{port}")
      @driver = Selenium::WebDriver.for(:chrome, options: options)
      @driver.navigate.to "http://www.javlibrary.com/ja/"
      wait = Selenium::WebDriver::Wait.new(:timeout => 60)
      prompt = wait.until { @driver.find_element(css: "#adultwarningprompt input") }
      prompt.click
    end

    def get(url)
      @driver.navigate.to url
      @driver.page_source
    end

    def search(keyword)
      return to_enum(:search, keyword) unless block_given?

      url = "http://www.javlibrary.com/ja/vl_searchbyid.php?keyword=#{keyword}"
      yield url, get(url)
      @driver.find_elements(css: "div.video > a").map { |a|
        a["href"]
      }.each { |href|
        yield href, get(href)
      }
    end

    def quit
      @driver.quit if @driver
    end
  end
end
