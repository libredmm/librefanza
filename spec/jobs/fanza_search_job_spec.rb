require "rails_helper"

RSpec.describe FanzaSearchJob, type: :job do
  include ActiveJob::TestHelper

  it "searches fanza" do
    id = generate :normalized_id

    expect(Fanza::Api).to receive(:item_list).with(id).and_call_original
    perform_enqueued_jobs do
      FanzaSearchJob.perform_later id
    end
  end

  it "creates fanza items" do
    expect(FanzaItem).to receive(:create).exactly(10).times

    id = generate :normalized_id
    perform_enqueued_jobs do
      FanzaSearchJob.perform_later id
    end
  end
end
