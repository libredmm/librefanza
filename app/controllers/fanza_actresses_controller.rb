class FanzaActressesController < ApplicationController
  include ItemsAggregator

  def index
    @actresses = FanzaActress.all.order(:id_fanza)
    @actresses = @actresses.page(params[:page])
  end

  def show
    @actress = FanzaActress.find_by(id_fanza: params[:id]) || FanzaActress.new(name: params[:id])
    fanza_query = @actress.persisted? ?
      FanzaItem.where(%{raw_json @> '{"iteminfo": {"actress": [{"id": #{@actress.id_fanza}}]}}'}) :
      FanzaItem.where(%{raw_json @> '{"iteminfo": {"actress": [{"name": "#{@actress.name}"}]}}'})
    mgstage_query = MgstageItem.where("actress_names @> ARRAY[?]::varchar[]", @actress.name)
    javlibrary_query = JavlibraryItem.where("actress_names @> ARRAY[?]::varchar[]", @actress.name)

    @items = aggregate_and_paginate(
      fanza_query,
      mgstage_query,
      javlibrary_query,
    )
  end
end
