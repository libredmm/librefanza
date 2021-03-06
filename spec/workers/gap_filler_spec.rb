require "rails_helper"

RSpec.describe GapFiller, type: :worker do
  it "fills gaps" do
    create :fanza_item, content_id: "ABC-001"
    create :fanza_item, content_id: "ABC-003"

    subject.perform "ABC"

    expect(MovieSearcher).to have_enqueued_sidekiq_job("ABC-002")
  end

  it "fills initial gaps" do
    create :fanza_item, content_id: "ABC-003"

    subject.perform "ABC"

    expect(MovieSearcher).to have_enqueued_sidekiq_job("ABC-001")
    expect(MovieSearcher).to have_enqueued_sidekiq_job("ABC-002")
  end

  it "stops at 999" do
    create :fanza_item, content_id: "ABC-1111"

    subject.perform "ABC"

    expect(MovieSearcher).to have_enqueued_sidekiq_job("ABC-999")
    expect(MovieSearcher).not_to have_enqueued_sidekiq_job("ABC-1000")
  end
end
