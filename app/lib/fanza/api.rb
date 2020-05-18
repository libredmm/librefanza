module Fanza
  class Api
    def self.item_list(keyword)
      JSON.parse(Faraday.get(
        "https://api.dmm.com/affiliate/v3/ItemList",
        {
          api_id: ENV["FANZA_API_ID"],
          affiliate_id: ENV["FANZA_AFFILIATE_ID"],
          site: "FANZA",
          hits: 100,
          sort: "date",
          keyword: keyword,
          output: "json",
        }
      ).body)
    end
  end
end
