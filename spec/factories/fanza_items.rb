FactoryBot.define do
  sequence :content_id do |i|
    "content#{format("%05d", i)}"
  end

  sequence :title do |i|
    "Item #{i}"
  end

  sequence :url do |i|
    "http://examle.com/#{i}"
  end

  factory :fanza_item do
    transient do
      content_id
      title
    end

    raw_json {
      {
        content_id: content_id,
        date: DateTime.now.to_s,
        title: title,
        imageURL: {
          large: generate(:url),
          small: generate(:url),
        },
        URL: generate(:url),
      }
    }
  end
end
