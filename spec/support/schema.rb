require "support/active_record_spec_helper"

module Schema
  def self.create
    ActiveRecord::Migration.verbose = false
    ActiveRecord::Schema.define do
      create_table :demographics, force: true do |t|
        t.integer :age, default: 0, null: false
        t.float :score, default: 0.0, null: false
      end
    end
  end
end

RSpec.configure do |config|
  config.before(:suite) do
    Schema.create
  end
end
