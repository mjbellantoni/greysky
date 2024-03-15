require "rails_helper"
require "support/mocks/geocodio_stubs"
require "support/mocks/nws_stubs"


RSpec.describe "Forecast searches", type: :system do

  include GeocodioStubs
  include NwsStubs

  before do
    driven_by(:rack_test)
  end

  def input_field
    find("input[placeholder=\"Search City or Zip Code\"]")
  end

  before(:each) do
    # Stub out the Geocodio API web request
    stub_geocodio_request_for_02134

    # Stub out the NWS API web requests
    stub_nws_points_request_for_02134
    stub_nws_gridbox_stations_request_for_BOX_64_90
    stub_nws_station_observations_request_for_KBOS
    stub_nws_gridpoints_forecast_request_for_BOX_64_90
  end

  scenario "the user provides a zip code" do
    # Given I'm on the home page
    visit root_path
    input_field.fill_in(with: "02134")

    # When I type a ZIP code into the input field
    #   And I click on the "Lookup" button
    click_on("Lookup")

    # Then I am taken to the forecast page
    #   And I see the name of the city
    #   And I am shown the current weather forecast for that ZIP code
    #   And I am shown the 7 day forecast for that ZIP code
    expect(page).to have_current_path(forecast_path("02134"))

    expect(page).to have_text("Allston")
    expect(page).to have_text("Current: 42")
    expect(page).to have_text("High: 48")
    expect(page).to have_text("Low: 37")
    expect(page).to have_text("Cloudy")

    expect(page).to have_css("table#forecast_periods tr", count: 14)
  end
end
