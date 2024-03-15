require "rails_helper"


RSpec.describe "Forecast searches", type: :system do

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
    stub_request(:get, "http://api.geocod.io/v1/geocode")
      .with(query: hash_including({"q" => "02134"}))
      .to_return(body: File.read("spec/support/mocks/geocodio_response_02134.json"))

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
