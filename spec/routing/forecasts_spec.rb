require "rails_helper"


RSpec.describe "Forecasts routing", type: :routing do
  describe "GET /forecasts/:zip_code" do
    it "routes to forecasts#show when :zip_code is well formed" do
      expect(get: "/forecasts/02134").to route_to(
                                           controller: "forecasts",
                                           action: "show",
                                           zip_code: "02134"
                                         )
    end

    it "doesn't route when :zip_code is malformed (non-digit)" do
      expect(get: "/forecasts/0213A").not_to be_routable
    end

    it "doesn't route when :zip_code is malformed (too short)" do
      expect(get: "/forecasts/0213").not_to be_routable
    end

    it "doesn't route when :zip_code is malformed (too long)" do
      expect(get: "/forecasts/021345").not_to be_routable
    end
  end
end
