require "rails_helper"

RSpec.describe MovieSearcher, type: :worker do
  before(:each) do
    allow(Fanza::Api).to receive(:search).and_call_original
    url = generate(:url)
    html = [generate(:url), "<html></html>"]
    allow(Mgstage::Api).to receive(:search).and_yield(url, html)
    allow(MgstagePage).to receive(:create)
  end

  it "ignores non ascii keyword" do
    expect(Fanza::Api).not_to receive(:search)
    subject.perform "你好"
  end

  it "crawls un-normalizable keyword" do
    keyword = "abc"
    expect(Fanza::Api).not_to receive(:search)
    subject.perform keyword
    expect(FanzaItemCrawler).to have_enqueued_sidekiq_job(keyword)
  end

  it "searches fanza first" do
    id = generate :normalized_id

    subject.perform id
    expect(Fanza::Api).to have_received(:search).with(id)
  end

  context "found on fanza" do
    it "stops there" do
      id = generate :normalized_id

      subject.perform id
      expect(Mgstage::Api).not_to have_received(:search)
      expect(JavlibraryScraper).not_to have_enqueued_sidekiq_job
    end
  end

  context "not found on fanza" do
    before(:each) do
      allow(Fanza::Api).to receive(:search).and_return([])
    end

    context "previously found on mgstage" do
      it "stops there" do
        item = create :mgstage_item
        id = item.normalized_id

        subject.perform id
        expect(Mgstage::Api).not_to have_received(:search).with(id)
      end
    end

    context "not previously found on mgstage" do
      it "searches mgstage next" do
        id = generate :normalized_id

        subject.perform id
        expect(Mgstage::Api).to have_received(:search).with(id)
      end

      context "found on mgstage" do
        it "stops there" do
          id = generate :normalized_id

          expect(MgstagePage).to receive(:create) {
            page = create :mgstage_product_page
            page.mgstage_item.update_column(:normalized_id, id)
            page
          }
          subject.perform id
          expect(JavlibraryScraper).not_to have_enqueued_sidekiq_job
        end
      end

      context "not found on mgstage" do
        it "schedules a javlibrary scraper job" do
          id = generate :normalized_id

          subject.perform id
          expect(JavlibraryScraper).to have_enqueued_sidekiq_job(id)
        end
      end
    end
  end
end
