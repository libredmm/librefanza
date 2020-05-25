RSpec.shared_examples "generic item" do
  %i[actresses cover_image_url date description directors genres labels makers review subtitle thumbnail_image_url title url].each do |key|
    it "has #{key}" do
      expect(subject.send(key)).not_to be_nil
    end
  end

  describe ".derive_fields!" do
    it "derives fields and saves changes" do
      expect(subject).to receive(:derive_fields).once do
        subject.normalized_id = subject.normalized_id + "0"
      end
      expect {
        subject.derive_fields!
        subject.reload
      }.to change {
        subject.normalized_id
      }
    end

    it "does not trigger save if no change" do
      expect(subject).not_to receive(:save)
      subject.derive_fields!
    end

    it "destroys itself when not passing validation" do
      expect(subject).to receive(:changed?).and_return(true)
      expect(subject).to receive(:save).and_return(false)
      expect {
        subject.derive_fields!
      }.to change {
        subject.destroyed?
      }.from(false).to(true)
    end
  end
end
