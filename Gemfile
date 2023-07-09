source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.4", ">= 7.0.4.1"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

gem "will_paginate", "~> 3.3"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

gem "roo"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem "rack-cors"

# ActiveModelSerializers brings convention over configuration to your JSON generation.
gem "active_model_serializers"

# Provide configurable, manageable, and safe stateful sessions based on JSON Web Tokens.
gem "jwt_sessions"

# A library for bulk insertion of data into your database using ActiveRecord [https://github.com/zdennis/activerecord-import]
gem "activerecord-import", "~> 1.4"

# Repository for collecting Locale data for Ruby on Rails I18 [https://github.com/svenfuchs/rails-i18n]
gem "rails-i18n", "~> 7.0.0"

# Axlsx is an Office Open XML Spreadsheet generator for the Ruby programming language
gem 'caxlsx'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]

  # RSpec testing framework to Ruby on Rails [https://github.com/rspec/rspec-rails]
  gem "rspec-rails", "~> 6.0.0"

  # Fixtures replacement with a straightforward definition syntax [https://github.com/thoughtbot/factory_bot_rails]
  gem "factory_bot_rails", "~> 6.2.0"
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end
