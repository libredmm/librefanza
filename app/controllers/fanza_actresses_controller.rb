class FanzaActressesController < ApplicationController
  # GET /fanza_actresses
  # GET /fanza_actresses.json
  def index
    @actresses = FanzaActress.all.order(:id_fanza)
    @actresses = @actresses.page(params[:page])
  end

  # GET /fanza_actresses/1
  # GET /fanza_actresses/1.json
  def show
    @actress = FanzaActress.find(params[:id])
  end
end
