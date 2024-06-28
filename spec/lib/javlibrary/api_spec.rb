require "rails_helper"

RSpec.describe Javlibrary::Api do
  describe "#search" do
    it "requests javlibrary" do
      id = generate :normalized_id
      Javlibrary::Api.search(id) { next }
      expect(@javlibrary_stub).to have_been_requested
    end

    it "requests all product page" do
      html = double(:html)
      expect(Nokogiri).to receive(:HTML).and_return(html)
      a = double(:a)
      expect(html).to receive(:css).and_return([a])
      url = "./elsewhere"
      expect(a).to receive(:attr).and_return(url)

      Javlibrary::Api.search(generate(:normalized_id)) { next }
      expect(@javlibrary_stub).to have_been_requested.twice
    end

    it "is no-op on fc2 ids" do
      Javlibrary::Api.search(generate(:fc2_id)) { break }
      expect(@javlibrary_stub).not_to have_been_requested
    end
  end
end
