require "rails_helper"

RSpec.describe SearchWorker, type: :worker do
  it "ignores non ascii keyword" do
    expect(Fanza::Api).not_to receive(:item_list)
    subject.perform "你好"
  end

  it "crawls un-normalizable keyword" do
    keyword = "abc"
    expect(Fanza::Api).not_to receive(:item_list)
    subject.perform keyword
    expect(CrawlWorker).to have_enqueued_sidekiq_job(keyword)
  end

  it "searches fanza first" do
    id = generate :normalized_id

    expect(Fanza::Api).to receive(:item_list).with(id).and_call_original
    subject.perform id
  end

  it "searches mgstage and javlibrary next" do
    id = generate :normalized_id

    expect(Fanza::Api).to receive(:item_list).with(id).and_return([].each)
    url = generate(:url)
    html = [generate(:url), "<html></html>"]
    expect(Mgstage::Api).to receive(:search).with(id).and_yield(url, html)
    expect(MgstagePage).to receive(:create).with(url: url, raw_html: html)

    subject.perform id
    expect(JavlibraryWorker).to have_enqueued_sidekiq_job(id)
  end

  it "only searches mgstage when necessary" do
    item = create :mgstage_item
    id = item.normalized_id

    expect(Fanza::Api).to receive(:item_list).with(id).and_return([].each)
    expect(Mgstage::Api).not_to receive(:search)

    subject.perform id
  end
end
