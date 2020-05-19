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
    return render if @item

    FanzaSearchJob.perform_later params[:id]
    find_javlibrary_item(params[:id])
    return render if @item

    JavlibrarySearchJob.perform_later params[:id]

    redirect_to "movies/index"
  end

  private

  def find_fanza_item(id)
    @item = FanzaItem.where(normalized_id: id).order(:date).first
  end

  def find_javlibrary_item(id)
    @item = JavlibraryItem.where(normalized_id: id).first
  end
end
