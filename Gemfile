source 'https://rubygems.org'

#gem 'rails', '3.2.11'
gem 'rails', '4.0.0'
gem 'haml-rails'
gem 'bootstrap-sass'
gem 'jquery-rails'
gem 'bcrypt-ruby', '= 3.0.1'
gem 'bootstrap_form'

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
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end

group :development do
  # advanced erros log
  gem 'better_errors'
  # detect N+1 queries issue
  gem 'bullet'
  # RailsPanel - Chrome extension for Rails development
  gem 'meta_request'

  gem 'sqlite3'
  gem 'pry'
  gem 'pry-nav'
end

group :production do
  gem 'pg'
end

