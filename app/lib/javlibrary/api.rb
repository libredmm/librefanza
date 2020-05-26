module Javlibrary
  class Api
    @@semaphore = Mutex.new

    def self.search(keyword)
      return to_enum(:search, keyword) unless block_given?

      @@semaphore.synchronize do
        client = Javlibrary::Client.new
        client.search(keyword) do |url, html|
          yield url, html
        end
      ensure
        client.quit if client
      end
    end
  end
end
