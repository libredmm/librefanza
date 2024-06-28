class Fc2ItemsController < ApplicationController
  # GET /fc2_items
  # GET /fc2_items.json
  def index
    @items = Fc2Item.order(:normalized_id).all
    @items = @items.page(params[:page])
    render "movies/items"
  end

  # GET /fc2_items/1
  # GET /fc2_items/1.json
  def show
    @item = Fc2Item.find(params[:id])
    render "movies/show"
  end

  # DELETE /fc2_items/1
  # DELETE /fc2_items/1.json
  def destroy
    @item = Fc2Item.find(params[:id])
    @item.derive_fields!
    render "movies/show"
  end
end
