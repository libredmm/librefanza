class FeedsController < ApplicationController
  before_action :set_feed, only: %i[ show destroy ]

  # GET /feeds
  def index
    @feeds = Feed.all
  end

  # GET /feeds/1
  def show
    render xml: @feed.content
  end

  # DELETE /feeds/1
  def destroy
    @feed.destroy!

    respond_to do |format|
      format.html { redirect_to feeds_url, notice: "Feed was successfully destroyed." }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feed
      @feed = Feed.find(params[:id])
    end
end
