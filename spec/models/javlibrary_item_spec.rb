require "rails_helper"

RSpec.describe JavlibraryItem, type: :model do
  subject { create(:javlibrary_item) }

  it_behaves_like "generic item"

  context "on destroy" do
    it "does not destroy movie that has other items" do
      id = subject.normalized_id
      create :fanza_item, content_id: id
      subject.destroy
      expect(Movie.where(normalized_id: id)).to exist
    end
  end

  it "uses cover image url of movie when available" do
    expect {
      subject.movie.cover_image_url = "dummy_url"
    }.to change {
      subject.cover_image_url
    }.to("https://imageproxy.libredmm.com/dummy_url")
  end

  describe "thumbnail_image_url" do
    context "when cover image is from dmm" do
      it "guesses thumbnail from dmm" do
        allow(subject).to receive(:cover_image_url).and_return(
          "http://pics.dmm.co.jp/mono/movie/adult/atad106/atad106pl.jpg"
        )
        expect(subject.thumbnail_image_url).to eq(
          "http://pics.dmm.co.jp/mono/movie/adult/atad106/atad106ps.jpg"
        )
      end
    end

    context "when cover image is not from dmm" do
      it "crops thumbnail from cover" do
        allow(subject).to receive(:cover_image_url).and_return("dummy_url")
        expect(subject.thumbnail_image_url).to eq("https://imageproxy.libredmm.com/cx.53/dummy_url")
      end
    end

    context "when cover image is overridden" do
      it "does not double proxy" do
        expect {
          subject.movie.cover_image_url = "dummy_url"
        }.to change {
          subject.thumbnail_image_url
        }.to("https://imageproxy.libredmm.com/cx.53/dummy_url")
      end
    end
  end
end
