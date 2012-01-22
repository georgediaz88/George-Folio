require 'sinatra'
require File.join(File.dirname(__FILE__), '..', 'app')
require 'bundler/setup'
require 'rack/test'
require 'test/unit'

#setup test env
#Bundler.require(:default, ENV['RACK_ENV'].to_sym)
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

def app
  GeorgeFolio::MyApp
end

RSpec.configure do |config|
  config.before(:each) do
    DataMapper.setup(:default, ENV["DATABASE_URL"] || "sqlite3://#{Dir.pwd}/folio_test.db")
    DataMapper.auto_migrate! #will wipe away each time vs upgrade! by changes
  end
  config.include Rack::Test::Methods
  config.color_enabled = true
end