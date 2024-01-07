FactoryBot.define do
  sequence :feed_uri do |i|
    "http://rss.example.com/#{i}"
  end

  factory :feed do
    uri { generate(:feed_uri) }
  end
end
