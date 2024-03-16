class Geocoder
  class Result
    attr_reader :lat
    attr_reader :lng
    attr_reader :city
    attr_reader :zip_code

    def self.from_geokit_results(results)
      new(results.lat, results.lng, results.city, results.zip)
    end

    def initialize(lat, lng, city, zip_code)
      @lat = lat
      @lng = lng
      @city = city
      @zip_code = zip_code
    end
  end

  def self.geocode(query)
    results = Geokit::Geocoders::GeocodioGeocoder.geocode(query.q)
    Geocoder::Result.from_geokit_results(results)
  end
end
