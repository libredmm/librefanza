class FanzaActressesController < ApplicationController
  # GET /fanza_actresses
  # GET /fanza_actresses.json
  def index
    @actresses = FanzaActress.all.order(:id_fanza)
    @actresses = @actresses.page(params[:page])
  end

  # GET /fanza_actresses/1
  # GET /fanza_actresses/1.json
  def show
    @actress = FanzaActress.find_by(id_fanza: params[:id])
    ids = FanzaItem.where(
      %{raw_json @> '{"iteminfo": {"actress": [{"id": #{@actress.id_fanza}}]}}'}
    ).distinct.pluck(:normalized_id).sort
    page_ids = Kaminari::paginate_array(ids).page(params[:page]).per(30)
    @items = page_ids.map { |id|
      FanzaItem.where(normalized_id: id).order(:date).first
    }
    @items = Kaminari::paginate_array(@items, total_count: ids.count).page(params[:page]).per(30)
  end
end
