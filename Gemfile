source :rubygems

gem 'sinatra'
gem 'haml'
gem 'sass'
gem 'pony'
gem 'datamapper', '>= 1.1.0'

group :development do
  gem 'dm-sqlite-adapter'
  gem 'tux'
  gem 'shotgun', :require => false
  gem 'thin', :require => false
end

group :test do
  gem 'rspec'
end

group :production do
  gem 'pg'
  gem 'dm-postgres-adapter'
end
