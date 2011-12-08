require "bundler/setup"
Bundler.require(:default, (ENV['RACK_ENV'] || "development").to_sym)

namespace :db do

  task :migrate do
    DataMapper.auto_upgrade!
  end

  task :migrate! do
    DataMapper.auto_migrate!
  end
end