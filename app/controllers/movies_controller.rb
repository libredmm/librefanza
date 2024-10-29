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
        @movies = @movies.with_prefix params[:q]
      else
        @style = :fuzzy
        @movies = @movies.fuzzy_match params[:q]
      end
    end
    @movies = @movies.page(params[:page])
  end

  def show
    id = params[:id].upcase
    @movie = Movie.find_by(normalized_id: id)
    @item = @movie&.preferred_item
    unless @item
      @searching = FanzaSearcher.perform_async id if signed_in? or request.format.json?
      @related_movies = Movie.fuzzy_match(id).order(:normalized_id).page(params[:page])
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

  def update
    id = params[:id].upcase
    @movie = Movie.find_by(normalized_id: id)
    @movie.update params.permit(:cover_image_url)
    redirect_to @movie
  end

  def destroy
    id = params[:id].upcase
    @movie = Movie.find_by(normalized_id: id)
    @searching = FanzaSearcher.perform_async id
    redirect_to @movie
  end
end
