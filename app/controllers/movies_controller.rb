class MoviesController < ApplicationController
  def index
    ids = (FanzaItem.distinct.pluck(:normalized_id) +
           JavlibraryItem.distinct.pluck(:normalized_id)).sort.uniq
    @items = ids.map { |id|
      find_fanza_item(id) || find_javlibrary_item(id)
    }
  end

  def show
    find_fanza_item(params[:id])
    unless @item
      FanzaItem.populate_from_fanza(id)
      find_javlibrary_item(params[:id])
    end
    unless @item
      JavlibraryPage.populate_from_javlibrary(id)
      raise ActiveRecord::RecordNotFound
    end
  end

  private

  def find_fanza_item(id)
    @item = FanzaItem.where(normalized_id: id).order(:date).first
  end

  def find_javlibrary_item(id)
    @item = JavlibraryItem.where(normalized_id: id).first
  end
end
