source 'https://rubygems.org'
ruby '2.1.0'

gem 'sinatra'
gem 'haml'
gem 'sass'
gem 'pony'
gem 'mongoid', '~> 3.1.2'
gem 'bson_ext'
gem 'twitter'
gem 'redis'
gem 'tweetstream'
gem 'active_attr'
gem 'foreman'
gem 'thin'

group :development do
  gem 'guard-rspec'
  gem 'rb-fsevent'
  gem 'sinatra-contrib'
  gem 'shotgun', :require => false
  gem 'pry'
end

group :test do
  gem 'rspec'
  gem 'capybara'
  gem 'factory_girl'
end

group :production do
  gem 'pg'
  gem 'dm-postgres-adapter'
end
