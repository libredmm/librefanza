class MoviesController < ApplicationController
  def index
    ids = FanzaItem.distinct.pluck(:normalized_id).sort
    @fanza_items = ids.map { |id|
      find_fanza_item(id)
    }
    render "fanza_items/index"
  end

  def show
    @fanza_item = find_fanza_item(params[:id])
    unless @fanza_item
      FanzaItem.populate_from_fanza(params[:id])
      @fanza_item = find_fanza_item(params[:id])
    end
    render "fanza_items/show"
  end

  private

  def find_fanza_item(id)
    @fanza_item = FanzaItem.where(normalized_id: id).order(:date).first
  end
end
