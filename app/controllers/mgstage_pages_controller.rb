class MgstagePagesController < ApplicationController
  # GET /mgstage_pages
  # GET /mgstage_pages.json
  def index
    @pages = MgstagePage.all
    @pages = @pages.page(params[:page])
  end

  # GET /mgstage_pages/1
  # GET /mgstage_pages/1.json
  def show
    @page = MgstagePage.find(params[:id])
    render html: @page.raw_html.html_safe
  end
end
