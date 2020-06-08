require "rails_helper"

RSpec.describe FanzaItemCrawler, type: :worker do
  it "works" do
    expect {
      subject.perform(1.day.ago, 1.day.from_now)
    }.to change {
      FanzaItem.count
    }
  end
end
