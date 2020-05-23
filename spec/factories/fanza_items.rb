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
    "http://examle.com/#{i}"
  end

  factory :fanza_item do
    transient do
      floor_code { "dvd" }
      content_id
      title
      maker_product { nil }
      actress { create(:fanza_actress) }
    end

    raw_json {
      {
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
