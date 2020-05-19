class JavlibrarySearchJob < ApplicationJob
  queue_as :default

  def perform(*keywords)
    keywords.each do |k|
      JavlibraryItem.populate_from_javlibrary k
    end
  end
end
