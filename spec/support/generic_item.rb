RSpec.shared_examples "generic item" do
  %i[actresses cover_image_url date description directors genres labels logo_url makers review subtitle thumbnail_image_url title url].each do |key|
    it "has #{key}" do
      expect(subject.send(key)).not_to be_nil
    end
  end

  it "has movie" do
    expect(subject.movie).to be_persisted
    expect(subject.movie.normalized_id).to eq(subject.normalized_id)
  end

  context "when normalized id changes" do
    it "still has movie with same normalized id" do
      expect {
        subject.update(normalized_id: "CHANGED-001")
      }.to change {
        subject.movie.normalized_id
      }.to("CHANGED-001")
    end

    it "destroys old obsolete movie" do
      old_id = subject.normalized_id
      new_id = "#{old_id}1"
      expect {
        subject.update(normalized_id: new_id)
      }.to change {
        Movie.exists?(normalized_id: old_id)
      }.from(true).to(false)
    end
  end

  context "on destroy" do
    it "destroys old obsolete movie" do
      id = subject.normalized_id
      expect {
        subject.destroy
      }.to change {
        Movie.exists?(normalized_id: id)
      }.from(true).to(false)
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
