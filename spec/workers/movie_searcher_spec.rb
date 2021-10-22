require "rails_helper"

RSpec.describe MovieSearcher, type: :worker do
  before(:each) do
    allow(Fanza::Api).to receive(:search).and_call_original
    url = generate(:url)
    html = [generate(:url), "<html></html>"]
    allow(Sod::Api).to receive(:search).and_yield(url, html)
    allow(Mgstage::Api).to receive(:search).and_yield(url, html)
    allow(SodPage).to receive(:create)
    allow(MgstagePage).to receive(:create)
  end

  it "ignores non ascii keyword" do
    expect(Fanza::Api).not_to receive(:search)
    subject.perform "你好"
  end

  context "with blackhole pattern" do
    it "blackholes matched keyword" do
      ENV["BLACKHOLE_PATTERN"] = "(carib|pondo)"
      expect(Fanza::Api).not_to receive(:search)
      subject.perform "CARIBPR-200901"
    end
  end

  context "without blackhole pattern" do
    it "blackholes nothing" do
      ENV["BLACKHOLE_PATTERN"] = nil
      id = "CARIBPR-200901"
      subject.perform id
      expect(Fanza::Api).to have_received(:search).with(keyword: id)
    end
  end

  it "ignores un-normalizable keyword" do
    expect(Fanza::Api).not_to receive(:search)
    subject.perform "abc"
  end

  it "searches fanza first" do
    id = generate :normalized_id

    subject.perform id
    expect(Fanza::Api).to have_received(:search).with(keyword: id)
  end

  context "found on fanza" do
    it "stops there" do
      id = generate :normalized_id

      subject.perform id
      expect(Mgstage::Api).not_to have_received(:search)
    end
  end

  context "not found on fanza" do
    before(:each) do
      allow(Fanza::Api).to receive(:search).and_return([])
    end

    context "previously found on sod" do
      it "stops there" do
        item = create :sod_item
        id = item.normalized_id

        subject.perform id
        expect(Sod::Api).not_to have_received(:search).with(id)
      end
    end

    context "not previously found on sod" do
      it "searches sod next" do
        id = generate :normalized_id

        subject.perform id
        expect(Sod::Api).to have_received(:search).with(id)
      end

      context "found on sod" do
        it "stops there" do
          id = generate :normalized_id

          expect(SodPage).to receive(:create) {
            page = create :sod_page
            page.sod_item.update_column(:normalized_id, id)
            page
          }
          subject.perform id
        end
      end

      context "not found on sod" do
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
            end
          end
        end
      end
    end
  end
end
