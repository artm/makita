require "active_record"

class Demographic < ActiveRecord::Base
  enum gender: [:unknown, :male, :female]
end
