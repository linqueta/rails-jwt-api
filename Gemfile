# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.4'

gem 'rails', '~> 6.0.0'
gem 'sqlite3'
gem 'puma'
gem 'bcrypt'
gem 'jwt'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'active_model_serializers', '~> 0.10.0'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'
  gem 'pry', '~> 0.12.2'
  gem 'rubocop', require: false
  gem 'factory_bot_rails'
end

group :test do
  gem 'rspec-rails', '~> 3.8'
  gem 'database_cleaner'
  gem 'json_matchers'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
