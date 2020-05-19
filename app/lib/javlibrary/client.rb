require "selenium-webdriver"

module Javlibrary
  class Client
    def initialize
      @driver = Selenium::WebDriver.for :chrome
      @driver.navigate.to "http://www.javlibrary.com/ja/"
      wait = Selenium::WebDriver::Wait.new(:timeout => 10)
      prompt = wait.until { @driver.find_element(css: "#adultwarningprompt input") }
      prompt.click
    end

    def get(url)
      @driver.navigate.to url
      @driver.page_source
    end
  end
end
