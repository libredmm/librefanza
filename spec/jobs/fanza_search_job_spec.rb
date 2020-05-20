require "rails_helper"

RSpec.describe FanzaSearchJob, type: :job do
  include ActiveJob::TestHelper

  before(:each) do
    @items = 5.times.map { |i| spy("item #{i}") }
    allow(Fanza::Api).to receive(:item_list) {
      {
        "result" => {
          "items" => @items,
        },
      }
    }
    allow(FanzaItem).to receive(:create)
  end

  it "searches fanza" do
    id = generate :normalized_id
    perform_enqueued_jobs do
      FanzaSearchJob.perform_later id
    end

    expect(Fanza::Api).to have_received(:item_list).with(id)
  end

  it "creates fanza items" do
    id = generate :normalized_id
    perform_enqueued_jobs do
      FanzaSearchJob.perform_later id
    end

    @items.each do |item|
      expect(FanzaItem).to have_received(:create).with(raw_json: item)
    end
  end
end
