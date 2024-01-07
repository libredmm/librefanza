require "rails_helper"

RSpec.describe Feed, type: :model do
  subject { create :feed }

  context "on create" do
    it "parses host" do
      expect(subject.host).not_to be_nil
    end

    it "fetches content" do
      expect(subject.content).not_to be_nil
    end

    it "rejects invalid uri" do
      expect {
        create :feed, uri: "http://bad.url"
      }.to raise_error ActiveRecord::RecordInvalid
    end

    it "rejects empty feed" do
      stub_request(:any, %r{rss.example.com}).to_return(
        body: %q{
  <?xml version="1.0" encoding="utf-8" ?>
  <rss version="2.0">
  <channel>
  <title>RSS Title</title>
  <link>https://example.com</link>
  </channel>
  </rss>
  },
      )
      expect {
        create :feed
      }.to raise_error ActiveRecord::RecordInvalid
    end
  end

  describe "refresh!" do
    it "updates content" do
      subject
      stub_request(:any, %r{rss.example.com}).to_return(
        body: %q{
  <?xml version="1.0" encoding="utf-8" ?>
  <rss version="2.0">
  <channel>
  <title>RSS Title</title>
  <link>https://example.com</link>
  <item>
  <title>Item 1</title>
  <link>https://example.com/items/1</link>
  </item>
  <item>
  <title>Item 2</title>
  <link>https://example.com/items/2</link>
  </item>
  <item>
  <title>Item 3</title>
  <link>https://example.com/items/3</link>
  </item>
  </channel>
  </rss>
  },
      )
      expect { subject.refresh! }.to change { subject.content }
    end

    it "raises error on invalid uri" do
      subject.uri = "http://bad.url"
      expect { subject.refresh! }.to raise_error ActiveRecord::RecordInvalid
    end
  end
end
