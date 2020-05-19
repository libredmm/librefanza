class MoviesController < ApplicationController
  def index
    ids = FanzaItem.distinct.pluck(:normalized_id).sort
    @fanza_items = ids.map { |id|
      find_fanza_item(id)
    }
    render "fanza_items/index"
  end

  def show
    find_fanza_item(params[:id])
    if @fanza_item
      render "fanza_items/show"
      return
    end

    find_javlibrary_item(params[:id])
    if @javlibrary_item
      render "javlibrary_items/show"
      return
    end

    raise ActiveRecord::RecordNotFound
  end

  private

  def find_fanza_item(id)
    @fanza_item = FanzaItem.where(normalized_id: id).order(:date).first
    unless @fanza_item
      FanzaItem.populate_from_fanza(id)
      @fanza_item = FanzaItem.where(normalized_id: id).order(:date).first
    end
  end

  def find_javlibrary_item(id)
    @javlibrary_item = JavlibraryItem.where(normalized_id: id).first
    unless @javlibrary_item
      JavlibraryPage.populate_from_javlibrary(id)
      @javlibrary_item = JavlibraryItem.where(normalized_id: id).first
    end
  end
end
