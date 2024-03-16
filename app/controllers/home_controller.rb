class HomeController < ApplicationController
  def index
    @query = Query.new(q: params[:q])
    if @query.valid?
      result = Geocoder.geocode(@query)
      redirect_to forecast_path(result.zip_code)
    else
      flash[:alert] = "Please enter a valid ZIP code or city and state."
      render :index
    end
  end
end
