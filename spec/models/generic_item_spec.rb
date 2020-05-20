RSpec.shared_examples "generic item" do
  %i[title subtitle cover_image_url thumbnail_image_url url date].each do |key|
    it "has #{key}" do
      expect(item.send(key)).to be_present
    end
  end
end
