require "open-uri"

class RssController < ApplicationController
  def pipe
    exclude = params.include?(:exclude) ? URI.parse(params[:exclude]).read.split.to_set: Set[]
    blacklist = params.include?(:blacklist) ? URI.parse(params[:blacklist]).read.split.to_set : Set[]
    whitelist = params.include?(:whitelist) ? URI.parse(params[:whitelist]).read.split.to_set : Set[]

    minus_guids = Set[]
    if params.include?(:minus)
      minus_feed = Feed.find_or_create_by(uri: params[:minus])
      Nokogiri::XML(minus_feed.content).xpath("//channel/item").each do |item|
        guid = item.xpath("./guid").text.upcase
        minus_guids << guid if guid.present?
      end
    end

    feed = Feed.find_or_create_by(uri: params[:src])
    src = Nokogiri::XML(feed.content)
    src.xpath("//channel/item").each do |item|
      title = item.xpath("./title").text.upcase
      guid = item.xpath("./guid").text.upcase

      if guid.present? && minus_guids.include?(guid)
        logger.debug "[MINUS] guid"
        item.remove
        next
      end

      excluded = title.split.to_set & exclude
      unless excluded.empty?
        logger.debug "[EXCLUDED] #{excluded}"
        item.remove
        next
      end

      series = title.split(/[-\s]/).map { |token|
        token.gsub(/^\d{3}/i, "")
      }.to_set

      in_whitelist = series & whitelist
      unless in_whitelist.empty?
        logger.debug "[IN_WHITELIST] #{in_whitelist}"
        next
      end

      in_blacklist = series & blacklist
      unless in_blacklist.empty?
        logger.debug "[IN_BLACKLIST] #{in_blacklist}"
        item.remove
        next
      end
    end
    render xml: src
  end
end
