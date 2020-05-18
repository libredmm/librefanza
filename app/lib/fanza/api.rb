require "open-uri"

module Fanza
  class Api
    def self.item_list(q)
      JSON.parse(URI.open("https://api.dmm.com/affiliate/v3/ItemList?api_id=#{ENV["FANZA_API_ID"]}&affiliate_id=#{ENV["FANZA_AFFILIATE_ID"]}&site=FANZA&hits=100&sort=match&keyword=#{q}&output=json").read)
    end
  end
end
