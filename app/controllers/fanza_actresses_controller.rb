class FanzaActressesController < ApplicationController
  def index
    @actresses = FanzaActress.all

    @order = params[:order]
    case params[:order]
    when /name/i
      @actresses = @actresses.order(:name)
    else
      @order = "New"
      @actresses = @actresses.order(fanza_id: :desc)
    end

    if params[:fuzzy]
      @actresses = @actresses.where("name ILIKE ?", "%#{params[:fuzzy]}%")
    end
    @actresses = @actresses.page(params[:page])
  end

  def show
    @actress = FanzaActress.find_by(fanza_id: params[:id]) ||
               FanzaActress.order(:fanza_id).find_by(name: params[:id]) ||
               FanzaActress.new(name: params[:id])

    raise ActiveRecord::RecordNotFound if @actress.is_hidden?

    @movies = @actress.movies.order(:normalized_id)
    @movies = @movies.solo if params[:solo]

    respond_to do |format|
      format.html {
        @movies = @movies.page(params[:page])
        render
      }
      format.json {
        render json: {
          name: @actress.name,
          fanza_id: @actress.fanza_id,
          image_url: @actress.image_url,
          movies: @movies.pluck(:normalized_id),
        }
      }
    end
  end
end
