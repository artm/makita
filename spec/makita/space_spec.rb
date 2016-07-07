require "spec_helper"
require "makita/space"
require "models/demographic"
require "support/tabular_seed"

class DemographicSpace < Makita::Space
  axis :age
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

  describe "::axes" do
    it "is empty for the base" do
      expect(Makita::Space.axes).to be_empty
    end

    it "lists axes for subclass" do
      expect(DemographicSpace.axes).not_to be_empty
    end
  end

  describe "#filtered" do
    context "without filters" do
      it "returns all records" do
        expect(demo_space.filtered.to_a).to match_array Demographic.all.to_a
      end
    end

    context "exact filter" do
      before do
        demo_space.filters = { age: 22 }
      end

      it "returns matching records" do
        expect(demo_space.filtered.size).to eq 1
      end
    end
  end
end
