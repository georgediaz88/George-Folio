source :rubygems

gem 'sinatra'
gem 'haml'
gem 'sass'
gem 'pony'
gem 'mongo'
gem 'mongoid', git: 'git://github.com/mongoid/mongoid.git'
gem 'bson_ext'
gem 'activesupport'
gem 'twitter'
gem 'redis'
gem 'tweetstream'
#gem 'datamapper', '>= 1.1.0'

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
  # gem 'dm-postgres-adapter'
end
