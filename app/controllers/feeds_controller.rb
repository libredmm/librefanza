class FeedsController < ApplicationController
  before_action :set_feed, only: %i[ show destroy update ]

  # GET /feeds
  def index
    @feeds = Feed.order(id: :asc).all
  end

  # GET /feeds/1
  def show
    render xml: @feed.content
  end

  # DELETE /feeds/1
  def destroy
    @feed.destroy!
    redirect_to feeds_url, notice: "Feed was successfully destroyed."
  end

  # PUT /feeds/1
  def update
    @feed.update!(feed_params)
    redirect_to feeds_url, notice: "Feed was successfully updated."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feed
      @feed = Feed.find(params[:id])
    end

    def feed_params
      params.require(:feed).permit(:tag)
    end
end
