class JavlibraryPagesController < ApplicationController
  def index
    @pages = JavlibraryPage.order(id: :desc).all
    @pages = @pages.page(params[:page])
    render "generic_pages/index"
  end

  def show
    @page = JavlibraryPage.find(params[:id])
    render html: @page.raw_html.html_safe
  end
end
