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
  config.include Rack::Test::Methods
  config.color_enabled = true
end