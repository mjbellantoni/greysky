class Query
  include ActiveModel::API
  include ActiveModel::Attributes

  attribute :q, :string

  validate do
    unless zip_code?
      errors.add(:base, "must be a valid ZIP code")
    end
  end

  def provided?
    q.present?
  end

  private

  def zip_code?
    q.present? && q.squish.match?(/\A\s*\d{5}\z/)
  end
end
