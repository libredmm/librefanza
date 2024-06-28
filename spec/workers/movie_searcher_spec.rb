require "rails_helper"

RSpec.describe MovieSearcher, type: :worker do
  before(:each) do
    allow(Fanza::Api).to receive(:search).and_call_original
    url = generate(:url)
    html = [generate(:url), "<html></html>"]
    allow(Mgstage::Api).to receive(:search).and_yield(url, html)
    allow(Javlibrary::Api).to receive(:search).and_yield(url, html)
    allow(Fc2::Api).to receive(:search).and_yield(url, html)
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
            item = create :mgstage_item, normalized_id: id
            item.mgstage_page
          }
          subject.perform id
          expect(Javlibrary::Api).not_to have_received(:search).with(id)
        end
      end

      context "not found on mgstage" do
        before(:each) do
          allow(Mgstage::Api).to receive(:search).and_return([])
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
            it "stops there" do
              id = generate :normalized_id

              expect(JavlibraryPage).to receive(:find_or_initialize_by) {
                item = create :javlibrary_item, normalized_id: id
                page = item.javlibrary_page
                expect(page).to receive(:save!).and_return(true)
                page
              }
              subject.perform id
            end
          end

          context "not found on javlibrary" do
            before(:each) do
              allow(Javlibrary::Api).to receive(:search).and_return([])
            end

            context "previously found on fc2" do
              it "stops there" do
                item = create :fc2_item
                id = item.normalized_id

                subject.perform id
                expect(Fc2::Api).not_to have_received(:search).with(id)
              end
            end

            context "not previously found on fc2" do
              it "searches fc2 next" do
                id = generate :fc2_id

                subject.perform id
                expect(Fc2::Api).to have_received(:search).with(id)
              end

              context "found on fc2" do
                it "stops there" do
                  id = generate :fc2_id

                  expect(Fc2Page).to receive(:create) {
                    item = create :fc2_item, normalized_id: id
                    item.fc2_page
                  }
                  subject.perform id
                end
              end
            end
          end
        end
      end
    end
  end
end
