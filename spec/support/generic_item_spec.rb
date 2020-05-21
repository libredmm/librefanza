RSpec.shared_examples "generic item" do
  %i[title subtitle cover_image_url thumbnail_image_url url date].each do |key|
    it "has #{key}" do
      expect(item.send(key)).to be_present
    end
  end

  describe ".derive_fields!" do
    it "derives fields and saves changes" do
      expect(item).to receive(:derive_fields).once do
        item.normalized_id = item.normalized_id + "0"
      end
      expect {
        item.derive_fields!
        item.reload
      }.to change {
        item.normalized_id
      }
    end
  end
end
