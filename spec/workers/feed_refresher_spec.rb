require "rails_helper"

RSpec.describe FeedRefresher, type: :worker do
  before(:each) do
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
</channel>
</rss>
},
    )
  end

  it "refreshes feeds" do
    10.times do |i|
      create :feed
    end
    
    new_content = %q{
<?xml version="1.0" encoding="utf-8" ?>
<rss version="2.0">
<channel>
<title>RSS Title</title>
<link>https://example.com</link>
<item>
<title>Item 1</title>
<link>https://example.com/items/1</link>
</item>
</channel>
</rss>
}
    stub_request(:any, %r{rss.example.com}).to_return(body: new_content)

    refresh_count = 0
    allow_any_instance_of(Feed).to receive(:refresh!).and_wrap_original do |m, *args|
      refresh_count += 1
      m.call(*args)
    end

    subject.perform(0, 10)
    expect(refresh_count).to eq(10)
    Feed.find_each do |feed|
      expect(feed.content).to eq(new_content)
    end
  end


  it "stops after reaching maximum failures" do
    10.times do |i|
      create :feed
    end
    
    refresh_cnt = 0
    allow_any_instance_of(Feed).to receive(:refresh!) do
      refresh_cnt += 1
      raise ActiveRecord::RecordInvalid
    end

    subject.perform(0, 5)
    expect(refresh_cnt).to eq(5)
  end
end
