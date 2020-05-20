require "open-uri"

class FanzaItemsController < ApplicationController
  # GET /fanza_items
  # GET /fanza_items.json
  def index
    @items = FanzaItem.order(:normalized_id, :date, :content_id).all
    @items = @items.page(params[:page])
    render "movies/index"
  end

  # GET /fanza_items/1
  # GET /fanza_items/1.json
  def show
    @item = FanzaItem.find(params[:id])
    render "movies/show"
  end
end
