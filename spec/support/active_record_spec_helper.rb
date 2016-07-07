require "yaml"
require "active_record"

def setup_db config
  attempts ||= 2
  ActiveRecord::Base.establish_connection config
  # have to call .connection to actually attempt
  # connecting in order to notice if the database
  # exits
  ActiveRecord::Base.connection
rescue ActiveRecord::NoDatabaseError => e
  unless (attempts -= 1).zero?
    ActiveRecord::Base.establish_connection config.merge("database" => "postgres")
    ActiveRecord::Base.connection.create_database config["database"]
    retry
  end
  raise
end

setup_db YAML.load_file("spec/support/database.yml")["test"]

RSpec.configure do |config|
  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end
