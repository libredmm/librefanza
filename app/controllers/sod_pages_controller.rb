class SodPagesController < ApplicationController
  def index
    @pages = SodPage.order(id: :desc).all
    @pages = @pages.page(params[:page])
    render "generic_pages/index"
  end

  def show
    @page = SodPage.find(params[:id])
    render html: @page.raw_html.html_safe
  end
end
