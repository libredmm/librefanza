FactoryBot.define do
  factory :fc2_page do
    transient do
      fixture_date { "2024-06-27" }
    end

    url {
      "https://adult.contents.fc2.com/article/3069309/"
    }

    raw_html {
      File.open(
        File.absolute_path(
          File.join(
            Rails.root,
            "spec/factories/fc2_pages",
            fixture_date,
            Base64.urlsafe_encode64(url, padding: false),
          )
        )
      ).read
    }
  end
end
