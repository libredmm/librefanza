require "open-uri"

class FanzaItemsController < ApplicationController
  # GET /fanza_items
  # GET /fanza_items.json
  def index
    @items = FanzaItem.order(:normalized_id).all
    @items = @items.page(params[:page])
    render "movies/items"
  end

  # GET /fanza_items/1
  # GET /fanza_items/1.json
  def show
    @item = FanzaItem.find(params[:id])
    respond_to do |format|
      format.html {
        render "movies/show"
      }
      format.json {
        render json: JSON.pretty_generate(@item.safe_json)
      }
    end
  end

  # DELETE /fanza_items/1
  # DELETE /fanza_items/1.json
  def destroy
    @item = FanzaItem.find(params[:id])
    @item.derive_fields!
    render "movies/show"
  end
end
