require "rails_helper"

RSpec.describe FanzaItem, type: :model do
  it "must have content id" do
    item = build(:fanza_item, content_id: "")
    item.raw_json[:content_id] = ""
    expect {
      item.save!
    }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
