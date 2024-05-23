require "rails_helper"

RSpec.describe FanzaItemCrawler, type: :worker do
  it "works" do
    expect {
      subject.perform
    }.to change {
      FanzaItem.count
    }
  end
end
