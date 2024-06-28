require "faraday_middleware"

module Javlibrary
  class Api
    def self.search(keyword)
      return to_enum(:search, keyword) unless block_given?
      return if keyword.starts_with?("FC2-")

      search_url = URI::join(
        ENV.fetch("JAVLIBRARY_BASE_URL", "https://www.javlibrary.com/"),
        "ja/vl_searchbyid.php?keyword=#{keyword}"
      )
      resp = Faraday.get(search_url)
      return if resp.status != 200
      yield search_url.to_s, resp.body

      html = Nokogiri::HTML(resp.body)
      html.css("div.video > a").map { |a|
        url = URI::join(search_url, a.attr(:href)).to_s
        yield url.to_s, Faraday.get(url).body
      }
    end
  end
end
