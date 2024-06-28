class Fc2PagesController < ApplicationController
  def index
    @pages = Fc2Page.order(id: :desc).all
    @pages = @pages.page(params[:page])
    render "generic_pages/index"
  end

  def show
    @page = Fc2Page.find(params[:id])
    render html: @page.raw_html.html_safe
  end
end
