module Fanza
  class Api
    def self.fetch_all
      all_payload = []
      offset = 1
      while true
        resp, payload = yield(offset)
        all_payload += payload

        result_count = resp["result"]["result_count"].to_i
        total_count = resp["result"]["total_count"].to_i
        first_position = resp["result"]["first_position"].to_i
        offset = first_position + result_count
        Rails.logger.info("#{offset - 1}/#{total_count}")
        break if offset > total_count
      end
      all_payload
    end

    def self.item_list(keyword)
      self.fetch_all do |offset|
        resp = JSON.parse(Faraday.get(
          "https://api.dmm.com/affiliate/v3/ItemList",
          {
            api_id: ENV["FANZA_API_ID"],
            affiliate_id: ENV["FANZA_AFFILIATE_ID"],
            site: "FANZA",
            hits: 100,
            offset: offset,
            sort: "match",
            keyword: keyword,
            output: "json",
          }
        ).body)
        [resp, resp["result"]["items"]]
      end
    end

    def self.actress_search(id: nil, keyword: nil)
      self.fetch_all do |offset|
        resp = JSON.parse(Faraday.get(
          "https://api.dmm.com/affiliate/v3/ActressSearch",
          {
            api_id: ENV["FANZA_API_ID"],
            affiliate_id: ENV["FANZA_AFFILIATE_ID"],
            actress_id: id,
            keyword: keyword,
            hits: 100,
            offset: offset,
            sort: "id",
            output: "json",
          }
        ).body)
        [resp, resp["result"]["actress"]]
      end
    end
  end
end
