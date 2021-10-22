class SodItemsController < ApplicationController
  # GET /sod_items
  # GET /sod_items.json
  def index
    @items = SodItem.order(:normalized_id).all
    @items = @items.page(params[:page])
    render "movies/items"
  end

  # GET /sod_items/1
  # GET /sod_items/1.json
  def show
    @item = SodItem.find(params[:id])
    render "movies/show"
  end

  # DELETE /sod_items/1
  # DELETE /sod_items/1.json
  def destroy
    @item = SodItem.find(params[:id])
    @item.derive_fields!
    render "movies/show"
  end
end
