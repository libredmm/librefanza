module Mgstage
  class Api
    def self.search(keyword)
      return to_enum(:search, keyword) unless block_given?

      search_url = "https://www.mgstage.com/search/search.php?search_word=#{keyword}"
      search_page = self.get(search_url)
      yield search_url, search_page
      Nokogiri::HTML(search_page).css("div.search_list h5 a").each do |a|
        url = "https://www.mgstage.com" + a.attr(:href)
        yield url, self.get(url)
      end
    end

    private

    def self.get(url)
      Faraday.get(url) { |req|
        req.headers = { "Cookie" => "adc=1" }
      }.body
    end
  end
end
