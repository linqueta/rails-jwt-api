# frozen_string_literal: true

require 'database_cleaner'
require 'json_matchers/rspec'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.before(:each) do
    DatabaseCleaner.start
    DatabaseCleaner.strategy = :transaction
  end
  config.after(:each) do
    Rails.cache.clear(::Auth::JsonWebToken::BLACKLIST_HEADER)
    DatabaseCleaner.clean
  end

  JsonMatchers.schema_root = 'spec/schemas'
end
