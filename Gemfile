source 'https://rubygems.org'

#gem 'rails', '3.2.11'
gem 'rails', '4.0.0'
gem 'haml-rails'
gem 'bootstrap-sass'
gem 'jquery-rails'
gem 'bcrypt-ruby', '= 3.0.1'
gem 'bootstrap_form'
gem "sidekiq"
gem "carrierwave"
gem "mini_magick"
gem 'stripe', :git => 'https://github.com/stripe/stripe-ruby'
gem "figaro"
gem 'draper', '~> 1.3'

group :assets do
  #gem 'sass-rails',   '~> 3.2.3'
  gem 'sass-rails', '~> 4.0.0'
  #gem 'coffee-rails', '~> 3.2.1'
  gem 'coffee-rails', '~> 4.0.0'
  #gem 'uglifier', '>= 1.0.3'
  gem 'uglifier', '>= 1.3.0'
end

group :test do
  gem 'shoulda-matchers'
  # nyan cat style for rspec
  gem "nyan-cat-formatter"
  gem "capybara"
  gem "selenium-webdriver"
  # gem "capybara-webkit" => unstable
  gem "database_cleaner"
  # open page in feature testing
  gem "launchy"
  # feature test for mail
  gem "capybara-email"
  # record 3rd party api service
  gem "vcr"
  gem "webmock", "~> 1.8.0"
end

group :development, :test do
  gem 'rspec-rails'
  #gem 'factory_girl_rails'
  gem 'faker'
  gem 'fabrication'
  gem 'pry'
  gem 'pry-nav'
end

group :development do
  # advanced erros log
  gem 'better_errors'
  # detect N+1 queries issue
  gem 'bullet'
  # RailsPanel - Chrome extension for Rails development
  gem 'meta_request'
  # Mail opener
  gem "letter_opener"

  gem 'sqlite3'
end

group :production do
  # for heroku
  gem "rails_12factor"
  gem 'pg'
  # for s3
  gem "fog"
  gem "unf"
end

