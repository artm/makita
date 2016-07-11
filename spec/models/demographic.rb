require "active_record"
require "bitmask_attributes"

class Demographic < ActiveRecord::Base
  enum gender: [:unknown, :male, :female]
  bitmask :body_mods, as: [:tattoo, :piercing, :scarring]
end
