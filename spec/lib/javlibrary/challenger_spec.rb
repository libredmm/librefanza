require "rails_helper"

RSpec.describe Javlibrary::Challenger do
  before(:each) do
    driver = spy(:driver)
    allow(driver).to receive_message_chain("manage.cookie_named").and_return({ value: "delicious" })
    allow(Selenium::WebDriver).to receive(:for).and_return(driver)
  end

  describe "#headers" do
    it "returns necessary headers" do
      headers = Javlibrary::Challenger.headers
      expect(headers).to include("User-Agent")
      expect(headers).to include("Cookie")
    end
  end
end
