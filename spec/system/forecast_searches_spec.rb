require "rails_helper"
require "support/mocks/geocodio_stubs"


RSpec.describe "Forecast searches", type: :system do

  include GeocodioStubs

  before do
    driven_by(:rack_test)
  end

  def input_field
    find("input[placeholder=\"Search City or Zip Code\"]")
  end

  scenario "the user provides a zip code" do
    # Don't stub out the NWS API for now
    WebMock.disable_net_connect!(allow: "https://api.weather.gov")

    # Stub out the Geocodio API web request
    stub_geocodio_request_for_02134

    # Given I'm on the home page
    visit root_path
    input_field.fill_in(with: "02134")

    # When I type a ZIP code into the input field
    #   And I click on the "Lookup" button
    click_on("Lookup")

    # Then I am taken to the forecast page
    #   And I see the name of the city
    #   And I am shown the weather forecast for that ZIP code
    expect(page).to have_current_path(forecast_path("02134"))
    expect(page).to have_text("Allston")
    expect(page).to have_text("Here is your weather forecast.")
  end
end
