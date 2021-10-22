FactoryBot.define do
  factory :sod_page do
    transient do
      fixture_date { "2021-10-22" }
    end

    url {
      "https://ec.sod.co.jp/prime/videos/?id=STARS-455"
    }

    raw_html {
      File.open(
        File.absolute_path(
          File.join(
            Rails.root,
            "spec/factories/sod_pages",
            fixture_date,
            Base64.urlsafe_encode64(url, padding: false),
          )
        )
      ).read
    }
  end
end
