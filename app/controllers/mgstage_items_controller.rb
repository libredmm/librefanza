class MgstageItemsController < ApplicationController
  # GET /mgstage_items
  # GET /mgstage_items.json
  def index
    @items = MgstageItem.order(:normalized_id).all
    @items = @items.page(params[:page])
    render "movies/items"
  end

  # GET /mgstage_items/1
  # GET /mgstage_items/1.json
  def show
    @item = MgstageItem.find(params[:id])
    render "movies/show"
  end

  # DELETE /mgstage_items/1
  # DELETE /mgstage_items/1.json
  def destroy
    @item = MgstageItem.find(params[:id])
    @item.derive_fields!
    render "movies/show"
  end
end
