class FanzaSearchJob < ApplicationJob
  queue_as :default

  def perform(*keywords)
    logger.info("Searching #{keywords} on Fanza")
    keywords.each do |keyword|
      Fanza::Api.item_list(keyword).map do |item|
        FanzaItem.create(
          raw_json: item,
        )
      end
    end
  end
end
