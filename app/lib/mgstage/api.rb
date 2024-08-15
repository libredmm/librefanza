module Mgstage
  class Api
    def self.search(keyword)
      return to_enum(:search, keyword) unless block_given?
      return if keyword.starts_with?("FC2-")

      Fanza::Id.variations(keyword).each do |variation|
        self.search_raw(variation) do |url|
          yield url, self.get(url).body
        end
      end
    end

    def self.search_raw(raw_keyword)
      1.upto(100) do |page|
        search_url = "https://www.mgstage.com/search/cSearch.php?search_word=#{raw_keyword}&page=#{page}"
        Rails.logger.info("[MGSTAGE] #{search_url}")
        search_resp = self.get(search_url)
        empty_page = true
        Nokogiri::HTML(search_resp.body).css("div.search_list h5 a").each do |a|
          url = URI::join(search_url, a.attr(:href)).to_s
          empty_page = false
          yield url
        end
        break if empty_page
      end
    end

    def self.get(url)
      Faraday.new(proxy: ENV["PROXY_URL"]).get(url) { |req|
        req.headers = { "Cookie" => "adc=1" }
      }
    end
  end
end
