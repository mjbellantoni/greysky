module GeocodioStubs
  def stub_geocodio_request_for_02134
    stub_request(:get, "http://api.geocod.io/v1/geocode")
      .with(query: hash_including({"q" => "02134"}))
      .to_return(body: File.read("spec/support/mocks/geocodio_response_02134.json"))
  end
end
