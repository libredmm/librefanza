class FanzaSearchJob < ApplicationJob
  queue_as :default

  def perform(*keywords)
    keywords.each do |keyword|
      Fanza::Api.item_list(keyword).map do |item|
        FanzaItem.create(
          raw_json: item,
        )
      end
    end
  end
end
