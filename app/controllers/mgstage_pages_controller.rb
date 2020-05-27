class MgstagePagesController < ApplicationController
  def index
    @pages = MgstagePage.order(id: :desc).all
    @pages = @pages.page(params[:page])
    render "generic_pages/index"
  end

  def show
    @page = MgstagePage.find(params[:id])
    render html: @page.raw_html.html_safe
  end
end
