require "rails_helper"

RSpec.describe ForecastPeriod, type: :model do
  describe ".from_nws_api_json" do
    it "sets precipitation_probability to 0 if not present in the JSON" do
      period_json =  {
        name: "Monday",
        temperature: 51,
        "probabilityOfPrecipitation" => {
          "unitCode" => "wmoUnit:percent",
          value: nil
        },
        "shortForecast" => "Mostly Sunny then Slight Chance Rain Showers",
      }.to_json

      period = ForecastPeriod.from_nws_api_json(period_json)

      expect(period.precipitation_probability).to eq(0)
    end
  end
end
