module Fanza
  class Api
    def self.search(keyword: nil, sort: "match", start_date: nil, end_date: nil)
      return to_enum(
               :search,
               keyword: keyword,
               sort: sort,
               start_date: start_date,
               end_date: end_date,
             ) unless block_given?

      Fanza::Id.variations(keyword).each do |variation|
        self.item_list(
          keyword: variation,
          sort: sort,
          start_date: start_date,
          end_date: end_date,
        ) do |item|
          yield item
        end
      end
    end

    def self.actress_search(id: nil, keyword: nil, offset: 1)
      return to_enum(
               :actress_search,
               id: id,
               keyword: keyword,
               offset: offset,
             ) unless block_given?

      self.fetch_all(offset: offset) do |offset|
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

    def self.item_list(keyword:, sort:, start_date:, end_date:)
      [
        ["mono", "dvd"],
        ["digital", "video"],
        ["digital", "videoa"],
        ["digital", "videoc"],
      ].each do |service, floor|
        self.item_list_in_floor(
          keyword: keyword,
          service: service,
          floor: floor,
          sort: sort,
          start_date: start_date,
          end_date: end_date,
        ) do |item|
          yield item
        end
      end
    end

    def self.item_list_in_floor(keyword:, service:, floor:, sort:, start_date:, end_date:)
      start_date = start_date.strftime("%Y-%m-%dT%H:%M:%S") if start_date.respond_to? :strftime
      end_date = end_date.strftime("%Y-%m-%dT%H:%M:%S") if end_date.respond_to? :strftime

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
            gte_date: start_date,
            lte_date: end_date,
            output: "json",
          }
        ).body)
        resp["result"]["items"]&.each do |item|
          yield item
        end
        resp
      end
    end

    def self.fetch_all(offset: 1)
      all_payload = []
      while true
        resp = yield offset
        result_count = resp["result"]["result_count"].to_i
        total_count = resp["result"]["total_count"].to_i
        first_position = resp["result"]["first_position"].to_i
        offset = first_position + result_count
        offset = 1 if offset < 1
        Rails.logger.info("[FANZA] #{offset - 1}/#{total_count}")
        break if offset > total_count
      end
      all_payload
    end
  end
end
