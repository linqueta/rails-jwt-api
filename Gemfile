# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.4'

gem 'rails', '~> 5.2.3'
gem 'sqlite3'
gem 'puma'
gem 'bcrypt'
gem 'jwt'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'active_model_serializers', '~> 0.10.0'
gem 'dotenv-rails'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rubocop'
  gem 'rubocop-performance'
end

group :test do
  gem 'database_cleaner'
  gem 'json_matchers'
  gem 'rspec-rails'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'simplecov', require: false
  gem 'simplecov-summary'
  gem 'simplecov-console'
  gem 'timecop'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
