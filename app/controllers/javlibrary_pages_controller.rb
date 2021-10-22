class JavlibraryPagesController < ApplicationController
  def index
    @pages = JavlibraryPage.order(id: :desc).all
    @pages = @pages.page(params[:page])
  end

  def show
    @page = JavlibraryPage.find(params[:id])
    render html: @page.raw_html.html_safe
  end

  def new
    @page = JavlibraryPage.new
  end

  def create
    attrs = params.require(:javlibrary_page).permit(:url, :raw_html)
    @page = JavlibraryPage.create(attrs)
    if @page.persisted?
      redirect_to (@page.javlibrary_item || @page)
    else
      render :new
    end
  end
end
