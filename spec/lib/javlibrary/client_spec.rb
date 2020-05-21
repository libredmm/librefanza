require "rails_helper"

RSpec.describe "Javlibrary::Client" do
  before(:each) do
    @driver = spy("driver")
    allow(@driver).to receive(:current_url) { generate :url }
    expect(Selenium::WebDriver).to receive(:for).and_return(@driver)
  end

  let!(:client) { Javlibrary::Client.new }

  describe ".search" do
    context "when landed on search page" do
      it "gets all product pages" do
        links = 3.times.map {
          { "href" => generate(:url) }
        }
        expect(@driver).to receive(:find_elements).and_return(links)

        id = generate :normalized_id
        expect(client.search(id).count).to eq(links.count + 1)
      end
    end
  end
end
