source :rubygems

gem 'sinatra'
gem 'heroku'
gem 'haml'
gem 'coffee-script'
gem 'sass'
gem 'pony'
gem 'datamapper', '>= 1.1.0'
gem 'twitter'

group :development do
  gem 'guard-rspec'
  gem 'dm-sqlite-adapter'
  gem 'tux'
  gem 'shotgun', :require => false
  gem 'thin', :require => false
  gem 'pry', :git => 'git://github.com/pry/pry.git'
end

group :test do
  gem 'rspec'
end

group :production do
  gem 'pg'
  gem 'dm-postgres-adapter'
end
