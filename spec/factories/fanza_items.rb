FactoryBot.define do
  sequence :content_id do |i|
    "content#{format("%05d", i)}"
  end

  sequence :normalized_id do |i|
    "NORMALIZED_#{format("%03d", i)}"
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
      maker_product { nil }
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
        affiliateURL: generate(:url),
        affiliateURLsp: generate(:url),
      }
    }
  end
end
