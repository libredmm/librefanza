require "selenium-webdriver"

module Javlibrary
  class Client
    def initialize
      initialize_driver
    end

    def initialize_driver
      user_agent = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.50 Safari/537.36"
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument("headless")
      options.add_argument("user-agent='#{user_agent}'")
      @driver = Selenium::WebDriver.for(:chrome, options: options)
      @driver.navigate.to "http://www.javlibrary.com/ja/"
      wait = Selenium::WebDriver::Wait.new(:timeout => 60)
      prompt = wait.until { @driver.find_element(css: "#adultwarningprompt input") }
      prompt.click
    end

    def get(url)
      tries = 0
      @driver.navigate.to url
      { @driver.current_url => @driver.page_source }
    rescue Selenium::WebDriver::Error::WebDriverError
      tries += 1
      retry if tries <= 1
    end

    def search(keyword)
      get("http://www.javlibrary.com/ja/vl_searchbyid.php?keyword=#{keyword}")
    end
  end
end
