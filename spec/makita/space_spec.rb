require "spec_helper"
require "makita/space"
require "models/demographic"

class DemographicSpace < Makita::Space
end

describe Makita::Space do
  subject(:demo_space) { DemographicSpace.new(Demographic.all) }

  describe "#filtered" do
    it "returns all records" do
      expect(demo_space.filtered.to_a).to match_array Demographic.all.to_a
    end
  end
end
