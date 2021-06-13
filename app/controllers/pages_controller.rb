class PagesController < ApplicationController
  def index
  end

  def search
    keyword = Fanza::Id.normalize(params[:q])
    redirect_to Fanza::Id.normalized?(keyword) ?
                  movie_path(keyword, format: params[:format]) :
                  movies_path(q: keyword, style: "prefix", order: "release_date")
  end
end
