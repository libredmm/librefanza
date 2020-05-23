module Javlibrary
  class Api
    def self.search(keyword)
      @@client ||= Javlibrary::Client.new
      return @@client.search(keyword)
    end
  end
end
