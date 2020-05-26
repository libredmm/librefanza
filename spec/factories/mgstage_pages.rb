FactoryBot.define do
  factory :mgstage_page do
    transient do
      fixture_date { "2020-05-25" }
    end

    factory :mgstage_search_page do
      url {
        "https://www.mgstage.com/search/search.php?search_word=ARA-168"
      }
    end

    factory :mgstage_product_page do
      url {
        "https://www.mgstage.com/product/product_detail/261ARA-168/"
      }
    end

    raw_html {
      File.open(
        File.absolute_path(
          File.join(
            Rails.root,
            "spec/factories/mgstage_pages",
            fixture_date,
            Base64.urlsafe_encode64(url, padding: false),
          )
        )
      ).read
    }
  end
end
