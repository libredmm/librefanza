class MoviesController < ApplicationController
  def index
    @movies = Movie.all

    @order = params[:order]&.downcase&.to_sym
    case @order
    when :release_date
      @movies = @movies.order(date: :desc, normalized_id: :desc)
    when :date_added
      @movies = @movies.order(id: :desc)
    else
      @order = :title
      @movies = @movies.order(:normalized_id)
    end

    if params[:q]
      @style = params[:style]&.downcase&.to_sym
      case @style
      when :prefix
        @movies = @movies.where("normalized_id ILIKE ?", "#{params[:q]}%")
      else
        @style = :fuzzy
        @movies = @movies.where("normalized_id ILIKE ?", "%#{params[:q]}%")
      end
    end
    @movies = @movies.page(params[:page])
  end

  def show
    id = params[:id].upcase
    @movie = Movie.find_by(normalized_id: id)
    @item = @movie&.preferred_item
    unless @item
      @searching = MovieSearcher.perform_async id
      @related_movies = Movie.where("normalized_id ILIKE ?", "%#{id}%").order(:normalized_id).page(params[:page])
    end

    respond_to do |format|
      format.html {
        if @item && !@movie.is_hidden?
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
end
