require "rails_helper"
require "support/mocks/nws_stubs"

RSpec.describe Forecast, type: :model do

  include NwsStubs

  describe "fetch_from_nws" do
    before(:each) do
      stub_nws_points_request_for_02134
      stub_nws_gridbox_stations_request_for_BOX_64_90
      stub_nws_station_observations_request_for_KBOS
      stub_nws_gridpoints_forecast_request_for_BOX_64_90
    end

    it "raises an exception if the ZIP code isn't set" do
      forecast = Forecast.new(city: "Boston")
      expect { forecast.fetch_from_nws(42, 71) }.to raise_error(ArgumentError, "`zip_code` is required")
    end
    it "raises an exception if city isn't set" do
      forecast = Forecast.new(zip_code: "02134")
      expect { forecast.fetch_from_nws(42, 71) }.to raise_error(ArgumentError, "`city` is required")
    end
    it "sets fetched_at to the current time" do
      forecast = Forecast.new(zip_code: "02134", city: "Allston")
      forecast.fetch_from_nws(42.3584,-71.1259)
      expect(forecast.fetched_at).to be_within(5.seconds).of(Time.current)
    end
  end
end
