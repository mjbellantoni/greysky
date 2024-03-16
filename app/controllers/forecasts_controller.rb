class ForecastsController < ApplicationController
  def show
    # Use Geokit to geocode the zipcode via the Geocodio API. The NWS
    # API needs a lat/lon pair to look up the forecast.
    results = Geokit::Geocoders::GeocodioGeocoder.geocode(params[:zip_code])
    lat, lon = results.lat, results.lng
    city = results.city

    @forecast = Forecast.fetch(params[:zip_code], lat, lon, city)
  end
end
