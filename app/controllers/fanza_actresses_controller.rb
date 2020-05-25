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
    @ids = FanzaItem.where(
      %{raw_json @> '{"iteminfo": {"actress": [{"id": #{@actress.id_fanza}}]}}'}
    ).distinct.pluck(:normalized_id).sort
    @items = @ids.map { |id|
      FanzaItem.where(normalized_id: id).order(:date).first
    }
    @items = Kaminari::paginate_array(@items, total_count: @items.count).page(1).per(@items.count + 1)
  end
end
