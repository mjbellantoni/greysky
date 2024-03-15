module NwsStubs
  def stub_nws_points_request_for_02134
    stub_request(:get, "https://api.weather.gov/points/42.3584,-71.1259")
      .to_return(body: File.read("spec/support/mocks/nws_points_response_for_02134.json"))
  end

  def stub_nws_gridbox_stations_request_for_BOX_64_90
    stub_request(:get, "https://api.weather.gov/gridpoints/BOX/69,90/stations")
      .to_return(body: File.read("spec/support/mocks/nws_gridpoints_stations_response_for_BOX_64_90.json"))
  end

  def stub_nws_station_observations_request_for_KBOS
    stub_request(:get, "https://api.weather.gov/stations/KBOS/observations/latest")
      .to_return(body: File.read("spec/support/mocks/nws_latest_observations_response_for_KBOS.json"))
  end

  def stub_nws_gridpoints_forecast_request_for_BOX_64_90
    stub_request(:get, "https://api.weather.gov/gridpoints/BOX/69,90/forecast")
      .to_return(body: File.read("spec/support/mocks/nws_gridpoints_forecast_response_for_BOX_64_90.json"))
  end
end
