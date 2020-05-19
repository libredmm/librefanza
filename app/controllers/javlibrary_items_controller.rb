class JavlibraryItemsController < ApplicationController
  # GET /javlibrary_items
  # GET /javlibrary_items.json
  def index
    @items = JavlibraryItem.all
  end

  # GET /javlibrary_items/1
  # GET /javlibrary_items/1.json
  def show
    @item = JavlibraryItem.find(params[:id])
    render "movies/show"
  end
end
