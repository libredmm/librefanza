class FanzaItemsController < ApplicationController
  before_action :set_fanza_item, only: [:show, :destroy]

  # GET /fanza_items
  # GET /fanza_items.json
  def index
    @fanza_items = FanzaItem.all
  end

  # GET /fanza_items/1
  # GET /fanza_items/1.json
  def show
  end

  # GET /fanza_items/new
  def new
    @fanza_item = FanzaItem.new
  end

  # POST /fanza_items
  # POST /fanza_items.json
  def create
    @fanza_item = FanzaItem.new(fanza_item_params)

    respond_to do |format|
      if @fanza_item.save
        format.html { redirect_to @fanza_item, notice: 'Fanza item was successfully created.' }
        format.json { render :show, status: :created, location: @fanza_item }
      else
        format.html { render :new }
        format.json { render json: @fanza_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fanza_items/1
  # DELETE /fanza_items/1.json
  def destroy
    @fanza_item.destroy
    respond_to do |format|
      format.html { redirect_to fanza_items_url, notice: 'Fanza item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fanza_item
      @fanza_item = FanzaItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def fanza_item_params
      params.require(:fanza_item).permit(:content_id, :raw_json)
    end
end
