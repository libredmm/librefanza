require "open-uri"

class RssController < ApplicationController
  def pipe
    plex = URI.parse(params[:plex]).read.split.to_set
    blacklist = params.include?(:blacklist) ? URI.parse(params[:blacklist]).read.split.to_set : Set[]
    whitelist = params.include?(:whitelist) ? URI.parse(params[:whitelist]).read.split.to_set : Set[]

    src = Nokogiri::XML URI.parse(params[:src]).open
    src.xpath("//channel/item").each do |item|
      title = item.xpath("./title").text.upcase

      in_plex = title.split.to_set & plex
      unless in_plex.empty?
        logger.debug "[MATCH_PLEX] #{in_plex}"
        item.remove
        next
      end

      series = title.split(/[-\s]/).map { |token|
        token.gsub(/^\d{3}/i, "")
      }.to_set

      in_whitelist = series & whitelist
      unless in_whitelist.empty?
        logger.debug "[MATCH_WHITELIST] #{in_whitelist}"
        next
      end

      in_blacklist = series & blacklist
      unless in_blacklist.empty?
        logger.debug "[MATCH_BLACKLIST] #{in_blacklist}"
        item.remove
        next
      end
    end
    render xml: src
  end
end
