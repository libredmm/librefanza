class MoviesController < ApplicationController
  def index
    fanza_query = FanzaItem.all
    mgstage_query = MgstageItem.all
    javlibrary_query = JavlibraryItem.all
    if params[:fuzzy]
      fanza_query = fanza_query.where("normalized_id ILIKE ?", "%#{params[:fuzzy]}%")
      mgstage_query = mgstage_query.where("normalized_id ILIKE ?", "%#{params[:fuzzy]}%")
      javlibrary_query = javlibrary_query.where("normalized_id ILIKE ?", "%#{params[:fuzzy]}%")
    end
    ids = (fanza_query.distinct.pluck(:normalized_id) +
           javlibrary_query.distinct.pluck(:normalized_id)).sort.uniq
    page_ids = Kaminari::paginate_array(ids).page(params[:page]).per(30)
    @items = page_ids.map { |id|
      find_fanza_item(id) || find_mgstage_item(id) || find_javlibrary_item(id)
    }
    @items = Kaminari::paginate_array(@items, total_count: ids.count).page(params[:page]).per(30)
  end

  def show
    find_fanza_item(params[:id])
    unless @item
      @searching = SearchWorker.perform_async params[:id]
      find_mgstage_item(params[:id]) || find_javlibrary_item(params[:id])
    end

    respond_to do |format|
      format.html {
        if @item
          render
        else
          render :not_found, status: :not_found
        end
      }
      format.json {
        if @item
          render
        elsif @searching
          render json: { err: "processing" }, status: :accepted
        else
          render json: { err: "not_found" }, status: :not_found
        end
      }
    end
  end

  private

  def find_fanza_item(id)
    @item = FanzaItem.where(normalized_id: id).order(:date).first
  end

  def find_mgstage_item(id)
    @item = MgstageItem.where(normalized_id: id).first
  end

  def find_javlibrary_item(id)
    @item = JavlibraryItem.where(normalized_id: id).first
  end
end
