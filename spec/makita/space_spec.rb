require "spec_helper"
require "makita/space"
require "models/demographic"
require "support/tabular_seed"

class DemographicSpace < Makita::Space
  axis :age, type: :cardinal
end

describe Makita::Space do
  before(:each) do
    TabularSeed.into Demographic,
      [:age],
      [18],
      [22],
      [68],
      [99]
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

  shared_examples_for "filtering" do |filter_params, expectation|
    it "with #{filter_params} returns #{expectation}" do
      subject.filters = filter_params
      expectation = public_send(expectation) if expectation.is_a? Symbol
      expect(match_against).to match_array expectation
    end
  end

  context "no filter" do
    let (:match_against) { demo_space.filtered }
    it_supports "filtering", {}, :full_set
  end

  context "cardinal filter" do
    let(:match_against) { demo_space.filtered.to_a.map(&:age) }
    it_supports "filtering", {age: "22"}, [22]
    it_supports "filtering", {age: "22-"}, [22, 68, 99]
    it_supports "filtering", {age: "-22"}, [18, 22]
    it_supports "filtering", {age: "22-68"}, [22, 68]
    it_supports "filtering", {age: "18,99"}, [18, 99]
    it_supports "filtering", {age: "18,68-99"}, [18, 68, 99]
    it_supports "filtering", {age: "-22,99"}, [18, 22, 99]
    it_supports "filtering", {age: "22~"}, [22, 68, 99]
    it_supports "filtering", {age: "~22"}, [18]
    it_supports "filtering", {age: "22~68"}, [22]
  end
end
