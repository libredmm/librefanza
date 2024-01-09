module Mgstage
  class Api
    def self.search(keyword)
      return to_enum(:search, keyword) unless block_given?

      Fanza::Id.variations(keyword).each do |variation|
        self.search_raw(variation) do |url|
          yield url, self.get(url).body
        end
      end
    end

    def self.search_raw(raw_keyword)
      search_url = "https://www.mgstage.com/search/cSearch.php?search_word=#{raw_keyword}"
      search_page = self.get(search_url).body
      Nokogiri::HTML(search_page).css("div.search_list h5 a").each do |a|
        url = URI::join(search_url, a.attr(:href)).to_s
        yield url
      end
    end

    def self.product_detail_url(code)
      "https://www.mgstage.com/product/product_detail/#{code}/"
    end

    def self.get(url)
      Faraday.get(url) { |req|
        req.headers = { "Cookie" => "adc=1" }
      }
    end
  end
end
