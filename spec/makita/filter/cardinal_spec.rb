require "spec_helper"
require "makita/filter/cardinal"
require "models/demographic"

describe Makita::Filter::Cardinal do
  let(:axis) { double("axis", model: Demographic, name: "score") }
  let(:filter_value) { nil }
  subject(:filter) { Makita::Filter::Cardinal.new(axis, filter_value) }

  describe "#describe" do
    it "is empty by default" do
      expect(filter.describe).to_not be_present
    end

    shared_examples "value description" do |value, expected_description|
      let(:filter_value) { value }
      let(:value_description) { filter.describe[:values].first }
      it "of #{value.inspect} as #{expected_description.inspect}" do
        expect(value_description).to eq expected_description
      end
    end

    it_supports "value description", "22", "22"
    it_supports "value description", "20~30", "20 tot 30"
    it_supports "value description", ["22"], "22"
    it_supports "value description", ["20~30"], "20 tot 30"
  end
end
