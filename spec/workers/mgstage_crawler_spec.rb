require "rails_helper"

RSpec.describe MgstageCrawler, type: :worker do
  it "crawl product pages" do
    expect(Mgstage::Api).to receive(:get).exactly(10).times.and_call_original
    subject.perform("abc", 1, 10)
  end
end
