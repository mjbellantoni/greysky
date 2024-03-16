class HomeController < ApplicationController
  def index
    @query = Query.new(q: params[:q])
    if @query.valid?
      results = Geokit::Geocoders::GeocodioGeocoder.geocode(params[:q])
      redirect_to forecast_path(results.zip)
    else
      flash[:alert] = "Please enter a valid ZIP code"
      render :index
    end
  end
end
