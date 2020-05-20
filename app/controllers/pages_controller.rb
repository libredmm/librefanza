class PagesController < ApplicationController
  def index
  end

  def search
    redirect_to movie_path(params[:q].upcase)
  end

  def whosyourdaddy
    godmode? ? mortal! : godmode!
    redirect_to root_path
  end
end
