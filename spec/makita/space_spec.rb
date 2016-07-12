require "spec_helper"
require "makita/space"
require "models/demographic"
require "support/tabular_seed"

class DemographicSpace < Makita::Space
  self.model = Demographic
  axis :age, type: :cardinal
  axis :score, type: :rational
  axis :gender, type: :enum
  axis :body_mods, type: :bitmask
end

describe Makita::Space do
  before(:each) do
    TabularSeed.into Demographic,
      [:age, :score,  :gender,                      :body_mods],
      [  18,   0.01,    :male,            [:tattoo, :piercing]],
      [  22,   0.01,  :female, [:tattoo, :piercing, :scarring]],
      [  68,   0.20,    :male,                       [:tattoo]],
      [  99,   0.50, :unknown,                              []]
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
    it_supports "filtering", {age: %w[18 99]}, [18, 99]
    it_supports "filtering", {age: %w[18 68-99]}, [18, 68, 99]
    it_supports "filtering", {age: %w[-22 99]}, [18, 22, 99]
    it_supports "filtering", {age: "22~"}, [22, 68, 99]
    it_supports "filtering", {age: "~22"}, [18]
    it_supports "filtering", {age: "22~68"}, [22]
  end

  context "rational filter" do
    let(:match_against) { demo_space.filtered.to_a.map(&:score) }
    it_supports "filtering", {score: "0.01"}, [0.01, 0.01]
    it_supports "filtering", {score: "-0.01"}, []
    it_supports "filtering", {score: "-0.01~0.01"}, []
    it_supports "filtering", {score: "-0.01~0.1"}, [0.01, 0.01]
    it_supports "filtering", {score: %w[-0.01 0.01 0.1 0.50]}, [0.01, 0.01, 0.50]
    it_supports "filtering", {score: "~0.3"}, [0.01, 0.01, 0.20]
    it_supports "filtering", {score: "0.3~"}, [0.50]
    it_supports "filtering", {score: %w[~0.1 0.3~]}, [0.01,0.01,0.50]
  end

  context "enum filter" do
    let(:match_against) { demo_space.filtered.to_a.map(&:gender) }
    it_supports "filtering", {gender: "male"}, %w[male male]
    it_supports "filtering", {gender: %w[female]}, %w[female]
    it_supports "filtering", {gender: %w[female male]}, %w[female male male]
  end

  context "bitmask filter" do
    let(:match_against) { demo_space.filtered.to_a.map(&:body_mods) }
    it_supports "filtering", {body_mods: "piercing"},
      [[:tattoo, :piercing], [:tattoo, :piercing, :scarring]]
    it_supports "filtering", {body_mods: %w[piercing]},
      [[:tattoo, :piercing], [:tattoo, :piercing, :scarring]]
    it_supports "filtering", {body_mods: %w[tattoo ~scarring]},
      [[:tattoo, :piercing], [:tattoo]]
  end

  describe "#filter_params" do
    it "is empty initially" do
      expect(demo_space.filter_params).to be_empty
    end

    context "with filters set" do
      let(:input_params) {{ age: "22", score: "0~0.2", gender: %w[male female] }}
      before(:each) do
        demo_space.filters = input_params
      end

      it "lists the params of the set filters" do
        expect(demo_space.filter_params).to match input_params
      end
    end
  end
end
