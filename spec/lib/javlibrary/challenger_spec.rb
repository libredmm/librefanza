require "rails_helper"

RSpec.describe Javlibrary::Challenger do
  before(:each) do
  end

  describe "#headers" do
    it "returns necessary headers" do
      driver = spy(:driver)
      # expect(driver).to receive_message_chain("manage.cookie_named").and_return({ value: "delicious" })
      # expect(Selenium::WebDriver).to receive(:for).and_return(driver)
      # expect(Javlibrary::Challenger).to receive(:sleep)

      headers = Javlibrary::Challenger.headers
      expect(headers).to include("User-Agent")
      expect(headers).to include("Cookie")
    end

    # it "raises error on time-out" do
    #   driver = spy(:driver)
    #   allow(driver).to receive_message_chain("manage.cookie_named").and_raise(
    #     Selenium::WebDriver::Error::NoSuchCookieError
    #   )
    #   expect(Selenium::WebDriver).to receive(:for).and_return(driver)
    #   expect(Javlibrary::Challenger).to receive(:sleep).at_least(:twice)

    #   expect {
    #     headers = Javlibrary::Challenger.headers
    #   }.to raise_error(Selenium::WebDriver::Error::NoSuchCookieError)
    # end
  end
end
