source :rubygems

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
# gem 'mongo'

group :development do
  gem 'guard-rspec'
  gem 'tux'
  gem 'shotgun', :require => false
  gem 'thin', :require => false
  gem 'pry', git: 'git://github.com/pry/pry.git'
  # gem 'dm-sqlite-adapter'
end

group :test do
  gem 'rspec'
  gem 'capybara'
end

group :production do
  gem 'pg'
  gem 'dm-postgres-adapter'
end
