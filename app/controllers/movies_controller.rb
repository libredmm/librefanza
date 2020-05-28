class MoviesController < ApplicationController
  include ItemsAggregator

  def index
    if params[:fuzzy]
      @items = fuzzy_match(params[:fuzzy])
    else
      @items = aggregate_and_paginate(
        FanzaItem.all,
        MgstageItem.all,
        JavlibraryItem.all,
      )
    end
  end

  def show
    @item = FanzaItem.order(date: :desc).find_by(normalized_id: params[:id])
    unless @item
      @searching = SearchWorker.perform_async params[:id]
      @item = MgstageItem.find_by(normalized_id: params[:id]) ||
              JavlibraryItem.find_by(normalized_id: params[:id])
      @related_items = fuzzy_match(params[:id])
    end

    respond_to do |format|
      format.html {
        if @item
          render
        else
          render :not_found, status: :not_found
        end
      }
      format.json {
        if @item
          render
        elsif @searching
          render json: { err: "processing" }, status: :accepted
        else
          render json: { err: "not_found" }, status: :not_found
        end
      }
    end
  end

  private

  def fuzzy_match(keyword)
    fanza_query = FanzaItem.where("normalized_id ILIKE ?", "%#{keyword}%")
    mgstage_query = MgstageItem.where("normalized_id ILIKE ?", "%#{keyword}%")
    javlibrary_query = JavlibraryItem.where("normalized_id ILIKE ?", "%#{keyword}%")

    aggregate_and_paginate(
      fanza_query,
      mgstage_query,
      javlibrary_query,
    )
  end
end
