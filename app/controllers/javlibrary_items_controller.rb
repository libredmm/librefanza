class JavlibraryItemsController < ApplicationController
  # GET /javlibrary_items
  # GET /javlibrary_items.json
  def index
    @items = JavlibraryItem.order(:normalized_id).all
    @items = @items.page(params[:page])
    render "movies/index"
  end

  # GET /javlibrary_items/1
  # GET /javlibrary_items/1.json
  def show
    @item = JavlibraryItem.find(params[:id])
    render "movies/show"
  end

  # DELETE /javlibrary_items/1
  # DELETE /javlibrary_items/1.json
  def destroy
    @item = JavlibraryItem.find(params[:id])
    @item.derive_fields!
    render "movies/show"
  end
end
