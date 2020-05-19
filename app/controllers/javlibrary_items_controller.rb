class JavlibraryItemsController < ApplicationController
  # GET /javlibrary_items
  # GET /javlibrary_items.json
  def index
    @javlibrary_items = JavlibraryItem.all
  end

  # GET /javlibrary_items/1
  # GET /javlibrary_items/1.json
  def show
    @javlibrary_item = JavlibraryItem.find(params[:id])
  end
end
