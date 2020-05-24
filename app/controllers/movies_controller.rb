class MoviesController < ApplicationController
  def index
    ids = (FanzaItem.distinct.pluck(:normalized_id) +
           JavlibraryItem.distinct.pluck(:normalized_id)).sort.uniq
    page_ids = Kaminari::paginate_array(ids).page(params[:page]).per(30)
    @items = page_ids.map { |id|
      find_fanza_item(id) || find_javlibrary_item(id)
    }
    @items = Kaminari::paginate_array(@items, total_count: ids.count).page(params[:page]).per(30)
  end

  def show
    find_fanza_item(params[:id])
    return render if @item
    SearchWorker.perform_async params[:id], true

    find_javlibrary_item(params[:id])
    return render if @item

    respond_to do |format|
      format.html
      format.json { render json: { err: "not_found" } }
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
