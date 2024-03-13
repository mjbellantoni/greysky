require "rails_helper"


RSpec.describe "Forecast searches", type: :system do

  before do
    driven_by(:rack_test)
  end

  def input_field
    find("input[placeholder=\"Search City or Zip Code\"]")
  end

  scenario "the user provides a zip code" do
    # Given I'm on the home page
    visit root_path
    input_field.fill_in(with: "02134")

    # When I type a ZIP code into the input field
    #   And I click on the "Lookup" button
    click_on("Lookup")

    # Then I am shown the weather forecast for that ZIP code
    expect(page).to have_text("Here is your weather forecast.")
  end
end
