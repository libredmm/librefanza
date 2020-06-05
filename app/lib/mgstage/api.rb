module Mgstage
  class Api
    def self.search(keyword)
      return to_enum(:search, keyword) unless block_given?

      Fanza::Id.variations(keyword).each do |variation|
        search_url = "https://www.mgstage.com/search/search.php?search_word=#{variation}"
        search_page = self.get(search_url)
        yield search_url, search_page
        Nokogiri::HTML(search_page).css("div.search_list h5 a").each do |a|
          url = URI::join(search_url, a.attr(:href)).to_s
          yield url, self.get(url)
        end
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
