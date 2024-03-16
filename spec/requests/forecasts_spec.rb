require "rails_helper"
require "support/mocks/geocodio_stubs"
require "support/mocks/nws_stubs"

RSpec.describe "Forecasts", type: :request do

  include GeocodioStubs
  include NwsStubs

  describe "GET /forecasts/:zip_code" do
    before(:each) do
      stub_geocodio_request_for_02134
      stub_nws_points_request_for_02134
      stub_nws_gridbox_stations_request_for_BOX_64_90
      stub_nws_station_observations_request_for_KBOS
      stub_nws_gridpoints_forecast_request_for_BOX_64_90
    end

    it "returns a 200 status code" do
      get forecast_path("02134")
      expect(response).to have_http_status(200)
    end
  end
end
