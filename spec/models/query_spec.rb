require "rails_helper"

RSpec.describe Query, type: :model do
  describe "#valid?" do
    it "is valid when the query contains a ZIP code" do
      query = Query.new(q: " 02134  ")
      expect(query).to be_valid
    end
    it "is valid when the query contains a city and state (no comma)" do
      query = Query.new(q: "Allston MA")
      expect(query).to be_valid
    end
    it "is valid when the query contains a city and state (with comma)" do
      query = Query.new(q: "south bend, in")
      expect(query).to be_valid
    end
    it "is valid when the query contains a city and state (with spaces)" do
      query = Query.new(q: "   los angeles, CA   ")
      expect(query).to be_valid
    end
    it "is valid when the query contains a city and state (with periods)" do
      query = Query.new(q: "   w. hollywood, CA   ")
      expect(query).to be_valid
    end
    it "is invalid when the query does not contain a ZIP code or city and state" do
      query = Query.new(q: " 0213 ")
      expect(query).not_to be_valid
      expect(query.errors[:base]).to include("must be a valid ZIP code or city and state")
    end
  end
end
