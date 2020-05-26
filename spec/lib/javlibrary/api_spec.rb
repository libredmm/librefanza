require "rails_helper"

RSpec.describe "Javlibrary::Api" do
  before(:each) do
    allow(Javlibrary::Challenger).to receive(:headers).and_return({})
  end

  describe "#search" do
    it "requests javlibrary" do
      id = generate :normalized_id
      Javlibrary::Api.search(id) { next }
      expect(@javlibrary_stub).to have_been_requested
    end
  end
end
