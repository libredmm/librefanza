class PagesController < ApplicationController
  def index
  end

  def search
    redirect_to movie_path(
      Fanza::Helper.normalize_id(params[:q].upcase)
    )
  end
end
