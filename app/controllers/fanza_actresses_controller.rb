class FanzaActressesController < ApplicationController
  def index
    @actresses = FanzaActress.all

    @order = params[:order]
    case params[:order]
    when /name/i
      @actresses = @actresses.order(:name)
    else
      @order = "New"
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

    joins = Movie.left_joins(:fanza_items, :mgstage_items, :javlibrary_items)
    if @actress.id_fanza
      @movies = joins.where(%{fanza_items.raw_json @> '{"iteminfo": {"actress": [{"id": #{@actress.id_fanza}}]}}'})
    else
      @movies = joins.where(%{fanza_items.raw_json @> '{"iteminfo": {"actress": [{"name": "#{@actress.name}"}]}}'})
    end
    @movies = @movies
      .or(joins.where("mgstage_items.actress_names @> ARRAY[?]::varchar[]", @actress.name))
      .or(joins.where("javlibrary_items.actress_names @> ARRAY[?]::varchar[]", @actress.name))
      .distinct

    @movies = @movies.page(params[:page])
  end
end
