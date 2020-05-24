require "rails_helper"

RSpec.describe "Javlibrary::Api" do
  before(:each) do
    if Javlibrary::Api.class_variable_defined? :@@client
      Javlibrary::Api.remove_class_variable :@@client
    end

    @client = spy("client")
    allow(Javlibrary::Client).to receive(:new).and_return(@client)
    url = generate(:url)
    html = [generate(:url), "<html></html>"]
    allow(@client).to receive(:search).and_yield(url, html)
  end

  describe "#search" do
    it "creates client" do
      id = generate :normalized_id
      Javlibrary::Api.search(id) { next }
      expect(Javlibrary::Client).to have_received(:new)
    end

    it "caches client" do
      id = generate :normalized_id
      Javlibrary::Api.search(id) { next }
      Javlibrary::Api.search(id) { next }
      expect(Javlibrary::Client).to have_received(:new).once
    end

    it "searches using client" do
      id = generate :normalized_id
      expect(@client).to receive(:search).with(id)
      Javlibrary::Api.search(id) { next }
    end
  end
end
