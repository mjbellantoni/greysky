class Geocoder

  CACHE_EXPIRATION = 24.hours
  class FailedGeocode < StandardError; end

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
  rescue
    Rails.cache.delete(cache_key(query.zip_code))
    raise FailedGeocode
  end

  def self.geocode_with_geokit(query)
    results = Geokit::Geocoders::GeocodioGeocoder.geocode(query.q)
    puts results.inspect
    # If the geocode fails to provide a ZIP code, or fails entirely we
    # consider it a failure.
    raise FailedGeocode unless results.success? && results.zip.present?
    Geocoder::Result.from_geokit_results(results)
  end
end
