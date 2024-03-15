require "rails_helper"

RSpec.describe Forecast, type: :model do
  describe "fetch_from_nws" do
    it "raises an exception if the ZIP code isn't set" do
      forecast = Forecast.new(city: "Boston")
      expect { forecast.fetch_from_nws(42, 71) }.to raise_error(ArgumentError, "`zip_code` is required")
    end
    it "raises an exception if city isn't set" do
      forecast = Forecast.new(zip_code: "02134")
      expect { forecast.fetch_from_nws(42, 71) }.to raise_error(ArgumentError, "`city` is required")
    end
  end
end
