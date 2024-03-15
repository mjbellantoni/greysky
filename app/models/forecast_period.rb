class ForecastPeriod
  include ActiveModel::API
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :temperature, :float
  attribute :precipitation_probability, :integer
  attribute :short_forecast, :string

  def self.from_nws_api_json(period_json)
    new(
      name: period_json["name"],
      temperature: period_json["temperature"],
      precipitation_probability: period_json["probabilityOfPrecipitation"]["value"] || 0,
      short_forecast: period_json["shortForecast"])
  end
end
