require "open-uri"

class FanzaItemsController < ApplicationController
  # GET /fanza_items
  # GET /fanza_items.json
  def index
    @fanza_items = FanzaItem.order(:normalized_id, :date, :content_id).all
  end

  # GET /fanza_items/1
  # GET /fanza_items/1.json
  def show
    @fanza_item = FanzaItem.find(params[:id])
  end

  # POST /fanza_items
  # POST /fanza_items.json
  def create
    @fanza_items = FanzaItem.populate_from_fanza(params[:q])
    render :index
  end
end
