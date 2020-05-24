require "rails_helper"

RSpec.describe SearchWorker, type: :worker do
  it "searches fanza first" do
    id = generate :normalized_id

    expect(Fanza::Api).to receive(:item_list).with(id).and_call_original.at_least(1).times
    subject.perform(id, true)
  end

  it "does not search javlibrary if fallback not allowed" do
    id = generate :normalized_id

    expect(Fanza::Api).to receive(:item_list).with(id).and_return([].each)
    expect(Javlibrary::Api).not_to receive(:search).with(id)

    subject.perform(id, false)
  end

  it "searches javlibrary if fallback allowed" do
    id = generate :normalized_id

    expect(Fanza::Api).to receive(:item_list).with(id).and_return([].each)

    pages = 5.times.map {
      [generate(:url), "<html></html>"]
    }.to_h
    expect(Javlibrary::Api).to receive(:search).with(id).and_return(pages)
    pages.each do |url, html|
      expect(JavlibraryPage).to receive(:create).with(url: url, raw_html: html)
    end

    subject.perform(id, true)
  end

  it "only searches javlibrary when necessary" do
    item = create :javlibrary_item
    id = item.normalized_id

    expect(Fanza::Api).to receive(:item_list).with(id).and_return([].each)
    expect(Javlibrary::Api).not_to receive(:search)

    subject.perform(id, true)
  end
end
