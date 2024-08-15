require "open-uri"

class FeedsController < ApplicationController
  before_action :set_feed, only: %i[ show destroy update ]

  # GET /feeds
  def index
    @feeds = Feed.order(id: :asc).all
  end

  # GET /feeds/1
  def show
    render xml: @feed.content
  end

  # DELETE /feeds/1
  def destroy
    @feed.destroy!
    redirect_to feeds_url, notice: "Feed was successfully destroyed."
  end

  # PUT /feeds/1
  def update
    @feed.update!(feed_params)
    redirect_to feeds_url, notice: "Feed was successfully updated."
  end

  # GET /feeds/pipe
  def pipe
    exclude = params.include?(:exclude) ? Faraday.get(params[:exclude]).body.split.to_set : Set[]
    blacklist = params.include?(:blacklist) ? Faraday.get(params[:blacklist]).body.split.to_set : Set[]
    whitelist = params.include?(:whitelist) ? Faraday.get(params[:whitelist]).body.split.to_set : Set[]

    minus_guids = Set[]
    if params.include? :minus
      minus = load_feed params[:minus]
      minus.xpath("//channel/item").each do |item|
        guid = item.xpath("./guid").text.upcase
        minus_guids << guid if guid.present?
      end
    end

    src = load_feed params[:src]
    src.xpath("//channel/item").each do |item|
      title = item.xpath("./title").text.upcase
      guid = item.xpath("./guid").text.upcase

      if guid.present? && minus_guids.include?(guid)
        logger.debug "[MINUS] #{guid}"
        item.remove
        next
      end

      excluded = title.split.map { |token|
        token[/\w+-\d+/]
      }.to_set & exclude
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

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_feed
    @feed = Feed.find(params[:id])
  end

  def feed_params
    params.require(:feed).permit(:tag)
  end

  def load_feed(uri)
    feed = Nokogiri::XML(
      params[:direct] == "1" ? Faraday.get(uri).body : Feed.by_uri(uri).content
    )
    if params[:normalize] == "1"
      feed.xpath("//channel/item").each do |node|
        guid = node.xpath("./guid").text.upcase
        next unless guid.present?
        item = FeedItem.where(guid: guid)
        if item.exists?
          node.replace(item.first.content)
          logger.debug "[NORMALIZE] node replaced: #{guid}"
        else
          FeedItem.create!(guid: guid, content: node.to_s)
          logger.debug "[NORMALIZE] node saved: #{guid}"
        end
      end
    end
    feed
  end
end
