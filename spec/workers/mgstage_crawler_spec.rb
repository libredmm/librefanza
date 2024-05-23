require "rails_helper"

RSpec.describe MgstageCrawler, type: :worker do
  before(:each) do
    stub_request(:any, %r{av_mgstage}).to_return(body: "ABC")
  end

  it "crawl product pages" do
    expect(Mgstage::Api).to receive(:search_raw).exactly(1).times.with("ABC").and_call_original
    expect(Mgstage::Api).to receive(:get).at_least(10).times.and_call_original
    subject.perform
  end
end
