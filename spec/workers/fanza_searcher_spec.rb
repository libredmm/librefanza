require "rails_helper"

RSpec.describe FanzaSearcher, type: :worker do
  before(:each) do
    described_class.clear_searched_keywords
  end

  describe ".lock_args" do
    it "returns only keyword regardless of options" do
      expect(described_class.lock_args(["ABC-123"])).to eq(["ABC-123"])
      expect(described_class.lock_args(["ABC-123", {}])).to eq(["ABC-123"])
      expect(described_class.lock_args(["ABC-123", { force: true }])).to eq(["ABC-123"])
    end
  end

  describe "search cooldown" do
    it "skips recently searched keywords" do
      id = generate :normalized_id
      described_class.mark_searched(id)

      expect(Fanza::Api).not_to receive(:search)
      subject.perform id
    end

    it "does not skip recently searched keywords when force is true" do
      id = generate :normalized_id
      described_class.mark_searched(id)

      subject.perform id, force: true
      expect(Fanza::Api).to have_received(:search)
    end

    it "marks keyword as searched after completion" do
      id = generate :normalized_id

      expect(described_class.recently_searched?(id)).to be false
      subject.perform id
      expect(described_class.recently_searched?(id)).to be true
    end

    it "cleans up expired keywords" do
      id = generate :normalized_id
      described_class.searched_keywords[id] = 2.days.ago

      expect(described_class.recently_searched?(id)).to be false
      expect(described_class.searched_keywords).not_to have_key(id)
    end
  end

  before(:each) do
    allow(Fanza::Api).to receive(:search).and_call_original
    url = generate(:url)
    html = [generate(:url), "<html></html>"]
    allow(Mgstage::Api).to receive(:search).and_yield(url, html)
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

  context "with force: true" do
    let(:existing_item) { create :fanza_item }
    let(:content_id) { existing_item.content_id }
    let(:new_title) { "Updated Title" }
    let(:new_json) { existing_item.raw_json.merge("title" => new_title, "content_id" => content_id) }

    before(:each) do
      allow(Fanza::Api).to receive(:search).and_yield(new_json)
    end

    it "updates existing fanza item" do
      id = existing_item.normalized_id

      expect {
        subject.perform(id, force: true)
      }.not_to change { FanzaItem.count }

      expect(existing_item.reload.title).to eq(new_title)
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
          expect(Fc2::Api).not_to have_received(:search).with(id)
        end
      end

      context "not found on mgstage" do
        before(:each) do
          allow(Mgstage::Api).to receive(:search).and_return([])
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
