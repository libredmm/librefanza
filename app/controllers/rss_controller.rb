require "open-uri"

class RssController < ApplicationController
  def pipe
    plex = URI.parse(params[:plex]).read.split.to_set
    blacklist = URI.parse(params[:blacklist]).read.split.to_set

    src = Nokogiri::XML URI.parse(params[:src]).open
    src.xpath("//channel/item").each do |item|
      title = item.xpath("./title").text

      in_plex = title.split.to_set & plex
      unless in_plex.empty?
        logger.debug in_plex
        item.remove
        next
      end

      in_blacklist = title.split(/[-\s]/).to_set & blacklist
      unless in_blacklist.empty?
        logger.debug in_blacklist
        item.remove
        next
      end
    end
    render xml: src
  end
end
