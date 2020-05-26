require "rails_helper"

RSpec.describe JavlibraryWorker, type: :worker do
  it "searches javlibrary" do
    id = generate :normalized_id

    url = generate(:url)
    html = [generate(:url), "<html></html>"]
    expect(Javlibrary::Api).to receive(:search).with(id).and_yield(url, html)
    expect(JavlibraryPage).to receive(:create).with(url: url, raw_html: html)

    subject.perform id
  end

  it "only performs search when necessary" do
    item = create :javlibrary_item
    id = item.normalized_id

    expect(Javlibrary::Api).not_to receive(:search)
    subject.perform id
  end
end
