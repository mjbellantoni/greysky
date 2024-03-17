require "rails_helper"
require "support/mocks/geocodio_stubs"
require "support/mocks/nws_stubs"

RSpec.describe Forecast, type: :model do

  include ActiveSupport::Testing::TimeHelpers
  include GeocodioStubs
  include NwsStubs

  describe ".cache_key" do
    it "returns a cache key based on the zip code" do
      expect(Forecast.cache_key("02134")).to eq("forecast-02134")
    end
  end

  describe ".fetch" do
    # The cache is disabled in the test environment by default. We need
    # to enable it for these tests.
    around(:each) do |example|
      original_cache_store = Rails.cache
      Rails.application.config.cache_store = :memory_store
      Rails.cache = ActiveSupport::Cache.lookup_store(Rails.application.config.cache_store)

      example.run

      Rails.cache.clear
      Rails.cache = original_cache_store
    end


    context "when the Forecast is not in the cache" do
      before(:each) do
        stub_geocodio_request_for_02134
        stub_nws_points_request_for_02134
        stub_nws_gridbox_stations_request_for_BOX_64_90
        stub_nws_station_observations_request_for_KBOS
        stub_nws_gridpoints_forecast_request_for_BOX_64_90
      end

      it "calls the Forecast.fetch_from_nws method" do
        expect(Forecast).to receive(:fetch_from_nws).with("02134", 42.35843, -71.12589, "Allston").and_call_original
        Forecast.fetch("02134", 42.35843, -71.12589, "Allston")
      end
    end

    context "when the Forecast is in the cache" do
      let(:forecast) { Forecast.new(
        city: "Allston",
        current_temp: 72,
        current_weather: "Sunny",
        fetched_at: Time.current,
        forecast_periods: [],
        high_temp: 80,
        low_temp: 60,
        zip_code: "02134"
      ) }

      before(:each) do
        stub_geocodio_request_for_02134
        Rails.cache.write(forecast.cache_key, forecast)
      end

      it "doesn't call the Forecast.fetch_from_nws method" do
        expect(Forecast).to_not receive(:fetch_from_nws)
        Forecast.fetch("02134", 42.35843, -71.12589, "Allston")
      end
    end

    context "when the Forecast is in the cache but it's expired" do
      let(:forecast) { Forecast.new(
        city: "Allston",
        current_temp: 72,
        current_weather: "Sunny",
        fetched_at: 31.minutes.ago,
        forecast_periods: [],
        high_temp: 80,
        low_temp: 60,
        zip_code: "02134"
      ) }

      before(:each) do
        stub_geocodio_request_for_02134
        stub_nws_points_request_for_02134
        stub_nws_gridbox_stations_request_for_BOX_64_90
        stub_nws_station_observations_request_for_KBOS
        stub_nws_gridpoints_forecast_request_for_BOX_64_90

        travel_to 31.minutes.ago { Rails.cache.write(forecast.cache_key, forecast) }
      end

      it "calls the Forecast.fetch_from_nws method" do
        expect(Forecast).to receive(:fetch_from_nws).with("02134", 42.35843, -71.12589, "Allston").and_call_original
        Forecast.fetch("02134", 42.35843, -71.12589, "Allston")
      end
    end
  end

  describe "#cache_key" do
    it "returns a cache key based on the zip code" do
      forecast = Forecast.new(zip_code: "02134")
      expect(forecast.cache_key).to eq("forecast-02134")
    end
  end

  describe "#fetch_from_nws" do
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

  describe "#newly_fetched?" do
    it "returns nil if fetched_at is nil" do
      forecast = Forecast.new(fetched_at: nil)
      expect(forecast.newly_fetched?).to be_nil
    end
    it "returns true if the forecast was fetched less than 1 minute ago" do
      freeze_time do
        forecast = Forecast.new(fetched_at: 59.seconds.ago)
        expect(forecast).to be_newly_fetched
      end
    end
    it "returns false if the forecast was fetched 1 minute ago" do
      freeze_time do
        forecast = Forecast.new(fetched_at: 1.minute.ago)
        expect(forecast).to_not be_newly_fetched
      end
    end
  end
end
