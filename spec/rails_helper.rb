# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require 'support/configs/simplecov_config'
SimpleCovConfig.configure

require 'spec_helper'
require File.expand_path('../config/environment', __dir__)
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

ShouldaMatchersConfig.configure

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.include AuthenticationHelper
  config.include JsonHelper

  CacheConfig.configure(config)
  DatabaseCleanerConfig.configure(config)
  FactoryBotConfig.configure(config)
end
