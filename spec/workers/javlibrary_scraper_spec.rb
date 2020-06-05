require "rails_helper"

RSpec.describe JavlibraryScraper, type: :worker do
  before(:each) do
    url = generate(:url)
    html = [generate(:url), "<html></html>"]
    allow(Javlibrary::Api).to receive(:search).and_yield(url, html)
    allow(JavlibraryPage).to receive(:create)
  end

  context "previously found on javlibrary" do
    it "stops there" do
      item = create :javlibrary_item
      id = item.normalized_id

      subject.perform id
      expect(Javlibrary::Api).not_to have_received(:search).with(id)
    end
  end

  context "not previously found on javlibrary" do
    it "searches javlibrary next" do
      id = generate :normalized_id

      subject.perform id
      expect(Javlibrary::Api).to have_received(:search).with(id)
    end

    context "found on javlibrary" do
      it "would be happy" do
        id = generate :normalized_id

        expect(JavlibraryPage).to receive(:find_or_initialize_by) {
          page = create :javlibrary_product_page
          page.javlibrary_item.update_column(:normalized_id, id)
          expect(page).to receive(:save!)
          page
        }
        subject.perform id
      end
    end
  end
end
