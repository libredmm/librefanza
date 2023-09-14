source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.3"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~>7.0.4"
# Use postgresql as the database for Active Record
gem "pg"
# Use Puma as the app server
gem "puma"
# Use SCSS for stylesheets
gem "sass-rails"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"
# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"
# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder"
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

gem "bootstrap_form", "~> 5.1"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "database_cleaner-active_record"
  gem "factory_bot_rails"
  gem "rspec-rails"
  gem "warning"
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "web-console"
  gem "listen"
  gem "dotenv-rails"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara"
  gem "rspec-sidekiq"
  # Easy installation and use of web drivers to run system tests with browsers
  gem "simplecov", require: false
  gem "webmock"
end

group :production do
  gem "honeybadger"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem "faraday"
gem "jquery-rails"
gem "recursive-open-struct"
gem "selenium-webdriver"
gem "webdrivers"
gem "nokogiri"
gem "kaminari"
gem "sidekiq", "<8"
gem "sidekiq-unique-jobs", "~> 7.1"
gem "redis", "~> 4"
gem "clearance"
gem "rack-mini-profiler"
gem "faraday_middleware"
gem "faraday-encoding"
gem "rexml"
gem "rack-attack"
