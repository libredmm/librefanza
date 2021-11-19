source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.2"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails"
# Use postgresql as the database for Active Record
gem "pg"
# Use Puma as the app server
gem "puma"
# Use SCSS for stylesheets
gem "sass-rails"
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem "webpacker"
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder"
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false
gem "bootstrap_form"

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
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen"
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
gem "sidekiq"
gem "sidekiq-unique-jobs"
gem "clearance"
gem "rack-mini-profiler"
gem "faraday_middleware"
gem "faraday-encoding"
gem "rexml"
