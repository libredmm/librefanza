class MoviesController < ApplicationController
  include ItemsAggregator

  def index
    fanza_query = FanzaItem.all
    mgstage_query = MgstageItem.all
    javlibrary_query = JavlibraryItem.all
    if params[:fuzzy]
      fanza_query = fanza_query.where("normalized_id ILIKE ?", "%#{params[:fuzzy]}%")
      mgstage_query = mgstage_query.where("normalized_id ILIKE ?", "%#{params[:fuzzy]}%")
      javlibrary_query = javlibrary_query.where("normalized_id ILIKE ?", "%#{params[:fuzzy]}%")
    end

    @items = aggregate_and_paginate(
      fanza_query,
      mgstage_query,
      javlibrary_query,
    )
  end

  def show
    find_fanza_item(params[:id])
    unless @item
      @searching = SearchWorker.perform_async params[:id]
      find_mgstage_item(params[:id]) || find_javlibrary_item(params[:id])
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

  def find_fanza_item(id)
    @item = FanzaItem.where(normalized_id: id).order(:date).first
  end

  def find_mgstage_item(id)
    @item = MgstageItem.where(normalized_id: id).first
  end

  def find_javlibrary_item(id)
    @item = JavlibraryItem.where(normalized_id: id).first
  end
end
