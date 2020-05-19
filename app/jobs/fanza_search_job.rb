class FanzaSearchJob < ApplicationJob
  queue_as :default

  def perform(*keywords)
    logger.info("Searching #{keywords} on Fanza")
    keywords.each do |k|
      FanzaItem.populate_from_fanza k
    end
  end
end
