source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

gem "rails", "~> 7.0.0"
gem "sprockets-rails"
# gem "mysql2", "~> 0.5", group: :development
gem "pg"
gem "puma", "~> 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false
gem 'devise'
gem 'webauthn', '~> 3.0'


group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'rspec-rails', '~> 4.0.0'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry-rails'
end

group :development do
  gem "web-console"
  gem 'rubocop', require: false
end

group :test do
  gem 'capybara', '~> 3.39'
  gem 'selenium-webdriver', '~> 4.10'
  gem 'webdrivers', '~> 5.3'
  gem 'shoulda-matchers', '~> 5.0'
  gem 'rails-controller-testing'
end