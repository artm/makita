require "spec_helper"
require "makita/space"
require "models/demographic"
require "support/tabular_seed"

class DemographicSpace < Makita::Space
end

describe Makita::Space do
  before(:each) do
    TabularSeed.into Demographic,
      [:age],
      [18],
      [22],
      [68]
  end

  subject(:demo_space) { DemographicSpace.new(Demographic.all) }

  describe "#filtered" do
    it "returns all records" do
      expect(demo_space.filtered.to_a).to match_array Demographic.all.to_a
    end
  end
end
