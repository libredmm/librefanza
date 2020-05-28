require "rails_helper"

RSpec.describe DbJanitor, type: :worker do
  it "fetches raw html for fanza items" do
    create :fanza_item
    expect_any_instance_of(FanzaItem).to receive(:fetch_html!)
    subject.perform
  end
end
