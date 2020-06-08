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
end
