class ForecastsController < ApplicationController
  def show
    query = Query.new(q: params[:zip_code])
    # Use Geocoder to geocode the ZIP code. The NWS API needs a lat/lng
    # pair to look up the forecast.
    result = Geocoder.geocode(query)
    @forecast = Forecast.fetch(result.zip_code, result.lat, result.lng, result.city)
  end
end
