class Query
  include ActiveModel::API
  include ActiveModel::Attributes

  attribute :q, :string

  validate do
    unless city_and_state? || zip_code?
      errors.add(:base, "must be a valid ZIP code or city and state")
    end
  end

  def provided?
    q.present?
  end

  def zip_code
    q&.squish
  end

  private

  def city_and_state?
    q.present? && q.squish.match?(/\A(\S+\s*)+[ ,][A-Z]{2}\z/i)
  end

  def zip_code?
    q.present? && q.squish.match?(/\A\s*\d{5}\z/)
  end
end
