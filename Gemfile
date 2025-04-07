# frozen_string_literal: true

source 'https://rubygems.org'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 8.0.2'
gem 'sqlite3'
# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'
# Vite.js integration in Ruby web apps [https://vite-ruby.netlify.app/]
gem 'vite_rails'
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem 'bcrypt', '~> 3.1.7'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem 'solid_cache'
gem 'solid_queue'
gem 'solid_cable'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

gem 'dotenv', '~> 3.1'

gem 'literal'
gem 'phlex-icons'

gem 'active_storage-blurhash'
gem 'image_processing'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'
  gem 'better_errors'
  gem 'binding_of_caller'
  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem 'brakeman', require: false
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'rubocop-capybara'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'
  gem 'colorize'
  gem 'ruby_ui', require: false, github: 'ruby-ui/ruby_ui', branch: 'main'
  gem 'annotaterb'
  gem 'letter_opener'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'selenium-webdriver'
end

gem 'authentication-zero', '~> 4.0'

gem 'phlex-rails', '~> 2.2', :github => 'phlex-ruby/phlex-rails'

gem 'tailwind_merge', '~> 1.1'

gem 'kube-dsl', '~> 0.8.3'
