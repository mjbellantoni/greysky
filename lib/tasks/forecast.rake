namespace :forecast do

  desc "Look up the forecast for a given zipcode"
  task zipcode: :environment do |args|
    # Use Geokit to geocode the zipcode via the Geocodio API. The NWS
    # API needs a lat/lon pair to look up the forecast.
    results = Geokit::Geocoders::GeocodioGeocoder.geocode("02134")
    lat, lon = results.lat, results.lng

    puts "lon: #{lon}"
    puts "lat: #{lat}"

    # The NWS API requires the lat/lon only has four decimal places. So,
    # we round them here.
    lat = lat.round(4)
    lon = lon.round(4)

    puts "lon: #{lon}"
    puts "lat: #{lat}"

    # Use the NWS API to look up the forecast for the lat/lon pair. This
    # first call doesn't contain the forecast, but it does contain URLs
    # to other resources that contain the forecast.
    points_response = Faraday.get("https://api.weather.gov/points/#{lat},#{lon}")
    points_response_body = JSON.parse(points_response.body)

    # To get the current temperature, we need to find the URL for a
    # weather station. This is a two step process. First, we get the
    # URL for the observation stations near the lat/lon pair.
    observation_stations_url = points_response_body["properties"]["observationStations"]
    puts "observation_stations_url: #{observation_stations_url}"

    observation_stations_response = Faraday.get(observation_stations_url)
    observation_stations_response_body = JSON.parse(observation_stations_response.body)

    # Then, we get the URL for the actual weather station. We'll use the
    # first one in the list. If we were a clever clogs, we'd fetch a few
    # and maybe interpolate between them.
    #
    # Strangely, we need to manually create the URL for the latest
    # observations as it's not provided in the response, unlike
    # everywhere else.
    station_id = observation_stations_response_body["features"][0]["properties"]["stationIdentifier"]
    station_latest_observations_url = "https://api.weather.gov/stations/#{station_id}/observations/latest"
    puts "station_latest_observations_url: #{station_latest_observations_url}"

    # Get the latest observations from the weather station.
    station_latest_observations_response = Faraday.get(station_latest_observations_url)
    station_latest_observations_response_body = JSON.parse(station_latest_observations_response.body)

    # The current temperature is in the response in Celsius. We'll
    # convert it to Fahrenheit.
    current_temp_in_c = station_latest_observations_response_body["properties"]["temperature"]["value"]
    current_temp_in_f = (current_temp_in_c * 9 / 5) + 32
    puts "current_temp_in_f: #{current_temp_in_f.round}"

    # There's also a nice text description of the current weather conditions.
    current_weather = station_latest_observations_response_body["properties"]["textDescription"]
    puts "current_weather: #{current_weather}"

    # I was told there's bonus points for getting the seven day
    # forecast, so we'll get that here.
    forecast_url = points_response_body["properties"]["forecast"]
    puts "forecast_url: #{forecast_url}"

    # Get the forecast for the next 7 days.
    forecast_response = Faraday.get(forecast_url)
    forecast_response_body = JSON.parse(forecast_response.body)

    # We'll print out the data basically as delivered from the API.
    forecast_periods = forecast_response_body["properties"]["periods"]
    forecast_periods.each do |period|
      puts "#{period["name"]}: #{period["temperature"]} -- #{period["probabilityOfPrecipitation"]["value"] || 0}% -- #{period["shortForecast"]}"
    end

    # It's a little ambiguous what "high" and "low" mean in the
    # forecast. I'm going to assume it's the high and low for the next
    # two forecast periods adjusted with the current temperature.
    forecast_and_current_temps = forecast_periods.take(2).pluck("temperature") + [current_temp_in_f]
    high_temp = forecast_and_current_temps.max
    low_temp = forecast_and_current_temps.min
    puts "high_temp: #{high_temp.round}"
    puts "low_temp: #{low_temp.round}"
  end


  desc "Look up the forecast for a given city and state"
  task city_and_state: :environment do |args|
    results = Geokit::Geocoders::GeocodioGeocoder.geocode("Boston, MA")
    puts results
  end
end
