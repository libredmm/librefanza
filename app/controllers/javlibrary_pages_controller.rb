class JavlibraryPagesController < ApplicationController
  # GET /javlibrary_pages
  # GET /javlibrary_pages.json
  def index
    @javlibrary_pages = JavlibraryPage.all
  end

  # GET /javlibrary_pages/1
  # GET /javlibrary_pages/1.json
  def show
    @javlibrary_page = JavlibraryPage.find(params[:id])
    render html: @javlibrary_page.raw_html.html_safe
  end

  # POST /javlibrary_pages
  # POST /javlibrary_pages.json
  def create
    @javlibrary_pages = JavlibraryPage.populate_from_javlibrary(params[:q])
    render :index
  end
end
