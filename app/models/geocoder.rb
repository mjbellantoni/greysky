class Geocoder

  CACHE_EXPIRATION = 24.hours

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

  def self.cache_key(zip_code)
    "geocoder-#{zip_code}"
  end

  def self.geocode(query)
    Rails.cache.fetch(cache_key(query.zip_code), expires_in: CACHE_EXPIRATION) do
      geocode_with_geokit(query)
    end
  end

  def self.geocode_with_geokit(query)
    results = Geokit::Geocoders::GeocodioGeocoder.geocode(query.q)
    Geocoder::Result.from_geokit_results(results)
  end
end
