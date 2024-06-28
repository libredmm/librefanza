module Sod
  class Api
    def self.search(keyword)
      return to_enum(:search, keyword) unless block_given?
      return if keyword.starts_with?("FC2-")

      Fanza::Id.variations(keyword).each do |variation|
        product_url = "https://ec.sod.co.jp/prime/videos/?id=#{variation}"
        yield product_url, self.get(product_url)
      end
    end

    private

    def self.get(url)
      Faraday.new { |conn|
        conn.use FaradayMiddleware::FollowRedirects
      }.get("https://ec.sod.co.jp/prime/_ontime.php") { |req|
        req.headers = {
          "Cookie" => "PHPSESSID=dummy_session",
          "Referer" => url,
        }
      }.body
    end
  end
end
