require "faraday_middleware"

module Javlibrary
  class Api
    def self.search(keyword)
      return to_enum(:search, keyword) unless block_given?

      search_url = "http://www.javlibrary.com/ja/vl_searchbyid.php?keyword=#{keyword}"
      page = get(search_url)
      yield search_url, page

      html = Nokogiri::HTML(page)
      html.css("div.video > a").map { |a|
        url = URI::join(search_url, a.attr(:href)).to_s
        yield url, get(url)
      }
    end

    private

    def self.get(url)
      headers = Javlibrary::Challenger.headers
      Faraday.new(headers: headers) { |conn|
        conn.use FaradayMiddleware::FollowRedirects
        conn.response :encoding
        conn.adapter Faraday.default_adapter
      }.get(url).body.encode("UTF-8", invalid: :replace, undef: :replace)
    end
  end
end
