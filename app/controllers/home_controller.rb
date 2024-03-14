class HomeController < ApplicationController
  def index
    redirect_to forecast_path("02134") if params[:q] == "02134"
  end
end
