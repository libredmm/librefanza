class PagesController < ApplicationController
  def index
  end

  def search
    redirect_to movie_path(params[:q].upcase)
  end
end
