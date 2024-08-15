module Fc2
  class Api
    def self.search(keyword)
      return to_enum(:search, keyword) unless block_given?
      return unless keyword.starts_with?("FC2-")

      url = URI.join(
        ENV.fetch("FC2_BASE_URL", "https://adult.contents.fc2.com/"),
        "article/#{keyword.split("-").last}/",
      )
      yield url.to_s, self.get(url)
    end

    private

    def self.get(url)
      Faraday.new(proxy: ENV["PROXY_URL"]).get(url).body
    end
  end
end
