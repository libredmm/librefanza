FactoryBot.define do
  sequence :content_id do |i|
    "content#{format("%05d", i)}"
  end

  sequence :normalized_id do |i|
    "NORMALIZED-#{format("%03d", i)}"
  end

  sequence :title do |i|
    "Item #{i}"
  end

  sequence :url do |i|
    "http://example.com/#{i}"
  end

  factory :fanza_item do
    transient do
      service_code { "mono" }
      floor_code { "dvd" }
      content_id
      title
      maker_product { nil }
      actress { create(:fanza_actress) }
    end

    raw_json {
      {
        service_code: service_code,
        floor_code: floor_code,
        content_id: content_id,
        title: title,
        URL: generate(:url),
        imageURL: {
          large: generate(:url),
          small: generate(:url),
        },
        affiliateURL: generate(:url),
        affiliateURLsp: generate(:url),
        date: DateTime.now.to_s,
        review: {
          count: 10,
          average: 4.0,
        },
        iteminfo: {
          actress: [{
            id: actress.id_fanza,
            name: actress.name,
          }],
        },
      }
    }
  end
end
