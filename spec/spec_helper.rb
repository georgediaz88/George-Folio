require 'bundler/setup'
require 'rack/test'
require 'capybara/rspec'

$VERBOSE = nil #silence warnings
ENV['RACK_ENV'] = 'test'
Bundler.require(:default, ENV['RACK_ENV'].to_sym)

#Load factories
Dir[File.dirname(__FILE__) + '/factories/*.rb'].each {|file| require file}

require File.join(File.dirname(__FILE__), '..', 'app')

def app
  GeorgeFolio::MyApp
end

Capybara.configure do |config|
  config.app = app
  config.default_driver = :selenium
end

RSpec.configure do |config|
  config.before(:each) do
    Mongoid::Sessions.default.collections.select {|c| c.name !~ /system/ }.each(&:drop)
  end
  config.include Rack::Test::Methods
  config.include Capybara::DSL
  config.color_enabled = true
end