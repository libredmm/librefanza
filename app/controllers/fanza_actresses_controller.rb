class FanzaActressesController < ApplicationController
  # GET /fanza_actresses
  # GET /fanza_actresses.json
  def index
    @actresses = FanzaActress.all.order(:id_fanza)
    @actresses = @actresses.page(params[:page])
  end
end
