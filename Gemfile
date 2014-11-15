source 'http://rubygems.org'

gem 'rails', '~> 3.2.3'
gem 'app_config', '~> 2.5.3'
gem 'puma'

gem 'nokogiri'
gem 'premailer-rails'

gem 'will_paginate', '~> 3.0'
gem 'dynamic_form'

gem 'sms_fu'
gem 'pony' # required by sms_fu, not in its gemspec >:(

gem 'geocoder'
gem 'nameable'

gem 'd3-rails'

# assets
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'tagsinput-rails'

group :development, :test do
  gem 'dotenv-rails'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'quiet_assets'
  gem 'letter_opener'
  gem 'sqlite3' # for tests
  gem 'simplecov', :require => false
end

group :production do
  gem 'rails_12factor'
  gem 'pg'
end
