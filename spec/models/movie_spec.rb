require "rails_helper"

RSpec.describe Movie, type: :model do
  context "on item change" do
    context "when no items left" do
      it "destroys itself" do
        item = create :fanza_item
        movie = item.movie

        expect {
          item.update(normalized_id: "CHANGED-001")
        }.to change {
          Movie.exists?(movie.id)
        }.from(true).to(false)
      end
    end

    context "when any item left" do
      it "keeps alive" do
        item = create :fanza_item
        movie = item.movie

        another_item = create :fanza_item
        another_item.update_column(:normalized_id, item.normalized_id)
        expect(another_item.movie).to eq(movie)

        expect {
          item.update(normalized_id: "CHANGED-001")
        }.not_to change {
          Movie.exists?(movie.id)
        }
      end
    end

    it "updates date" do
      item = create :fanza_item
      movie = item.movie

      another_item = create :fanza_item
      another_item.update_column(:normalized_id, item.normalized_id)

      expect {
        another_item.update(date: 1.day.ago)
      }.to change {
        movie.reload.date
      }
    end
  end

  it "prefers fanza items" do
    javlibrary_item = create :javlibrary_item
    fanza_item = create :fanza_item, content_id: javlibrary_item.normalized_id
    movie = javlibrary_item.movie

    expect(fanza_item.movie).to eq(movie)
    expect(movie.preferred_item).to eq(fanza_item)
    expect(fanza_item.preferred?).to eq(true)
    expect(javlibrary_item.preferred?).to eq(false)
  end

  it "prefers fanza items with highest priority" do
    low_pri = create :fanza_item
    hi_pri = create :fanza_item, content_id: low_pri.normalized_id, priority: 1
    movie = low_pri.movie

    expect(movie.preferred_item).to eq(hi_pri)
    expect(hi_pri.preferred?).to eq(true)
    expect(low_pri.preferred?).to eq(false)
  end
end
