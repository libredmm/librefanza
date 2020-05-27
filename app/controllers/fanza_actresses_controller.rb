class FanzaActressesController < ApplicationController
  include ItemsAggregator

  def index
    @actresses = FanzaActress.all

    @order = params[:order]
    case params[:order]
    when /name/i
      @actresses = @actresses.order(:name)
    when /id/i
      @actresses = @actresses.order(id_fanza: :desc)
    else
      @order = "ID"
      @actresses = @actresses.order(id_fanza: :desc)
    end

    if params[:fuzzy]
      @actresses = @actresses.where("name ILIKE ?", "%#{params[:fuzzy]}")
    end
    @actresses = @actresses.page(params[:page])
  end

  def show
    @actress = FanzaActress.find_by(id_fanza: params[:id]) ||
               FanzaActress.order(:id_fanza).find_by(name: params[:id]) ||
               FanzaActress.new(name: params[:id])
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
