class JavlibraryPagesController < ApplicationController
  # GET /javlibrary_pages
  # GET /javlibrary_pages.json
  def index
    @pages = JavlibraryPage.order(:id).all
    @pages = @pages.page(params[:page])
  end

  # GET /javlibrary_pages/1
  # GET /javlibrary_pages/1.json
  def show
    @page = JavlibraryPage.find(params[:id])
    render html: @page.raw_html.html_safe
  end
end
