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

  let(:full_set) { Demographic.all }
  subject(:demo_space) { DemographicSpace.new(full_set) }

  describe "::axes" do
    it "is empty for the base" do
      expect(Makita::Space.axes).to be_empty
    end

    it "lists axes for subclass" do
      expect(DemographicSpace.axes).not_to be_empty
    end
  end

  describe "#filtered" do
    subject(:filtered) { demo_space.filtered }
    subject(:filtered_ages) { filtered.map(&:age) }

    context "without filters" do
      it "contains full set" do
        expect(filtered).to match_array full_set
      end
    end

    context "filter on value" do
      before do
        demo_space.filters = { age: 22 }
      end

      it "contains matching records" do
        expect(filtered_ages).to match_array [ 22 ]
      end
    end

    context "ge-filter" do
      before do
        demo_space.filters = { age: { ge: 22 } }
      end

      it "contains matching records" do
        expect(filtered_ages).to match_array [ 22, 68 ]
      end
    end
  end
end
