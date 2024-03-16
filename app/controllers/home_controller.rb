class HomeController < ApplicationController
  def index
    @query = Query.new(q: params[:q])
    if @query.valid?
      redirect_to forecast_path(@query.q)
    else
      flash[:alert] = "Please enter a valid ZIP code"
      render :index
    end
  end
end
