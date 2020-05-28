require "rails_helper"

RSpec.describe FanzaItemCrawler, type: :worker do
  it "searches fanza sorted by date" do
    id = generate :normalized_id

    expect(Fanza::Api).to receive(:item_list).with(id, sort: "date").and_call_original
    subject.perform id
  end
end
