module Fanza
  class Api
    def self.item_list(keyword, sort: "match")
      return to_enum(:item_list, keyword, sort: sort) unless block_given?

      [
        ["mono", "dvd"],
        ["digital", "video"],
        ["digital", "videoa"],
        ["digital", "videoc"],
      ].each do |service, floor|
        self.item_list_in_floor(keyword, service: service, floor: floor, sort: sort) do |item|
          yield item
        end
      end
    end

    def self.actress_search(id: nil, keyword: nil)
      return to_enum(:actress_search, id: id, keyword: keyword) unless block_given?

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
        resp["result"]["actress"].each do |actress|
          yield actress
        end
        resp
      end
    end

    private

    def self.item_list_in_floor(keyword, service:, floor:, sort:)
      self.fetch_all do |offset|
        resp = JSON.parse(Faraday.get(
          "https://api.dmm.com/affiliate/v3/ItemList",
          {
            api_id: ENV["FANZA_API_ID"],
            affiliate_id: ENV["FANZA_AFFILIATE_ID"],
            site: "FANZA",
            service: service,
            floor: floor,
            hits: 100,
            offset: offset,
            sort: sort,
            keyword: keyword,
            output: "json",
          }
        ).body)
        resp["result"]["items"].each do |item|
          yield item
        end
        resp
      end
    end

    def self.fetch_all
      all_payload = []
      offset = 1
      while true
        resp = yield offset
        result_count = resp["result"]["result_count"].to_i
        total_count = resp["result"]["total_count"].to_i
        first_position = resp["result"]["first_position"].to_i
        offset = first_position + result_count
        Rails.logger.info("#{offset - 1}/#{total_count}")
        break if offset > total_count
      end
      all_payload
    end
  end
end
