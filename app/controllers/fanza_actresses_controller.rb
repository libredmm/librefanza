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

    @movies = @actress.movies.page(params[:page])
  end
end
