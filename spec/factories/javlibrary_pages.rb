FactoryBot.define do
  factory :javlibrary_page do
    transient do
      fixture_date { "2020-05-20" }
    end

    factory :javlibrary_search_page do
      url {
        "http://www.javlibrary.com/ja/vl_searchbyid.php?keyword=ABP-001"
      }
    end

    factory :javlibrary_product_page do
      url {
        "http://www.javlibrary.com/ja/?v=javlio354y"
      }
    end

    raw_html {
      File.open(
        File.absolute_path(
          File.join(
            Rails.root,
            "spec/factories/javlibrary_pages",
            fixture_date,
            Base64.urlsafe_encode64(url, padding: false),
          )
        )
      ).read
    }
  end
end
