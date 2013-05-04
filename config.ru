#LoadGems
require 'bundler/setup'
require 'sinatra'

ENV['RACK_ENV'] ||= 'development'
Bundler.require(:default, (ENV['RACK_ENV'].to_sym))

enable :sessions
set :run, false
set :raise_errors, true
#set :views, proc { File.join(root, "templates") }

vars_path = File.join(File.dirname(__FILE__), 'config', 'local_vars.rb')
load(vars_path) if File.exists? vars_path

require File.join(File.dirname(__FILE__), 'app')

Twitter.configure do |config|
  config.consumer_key       = ENV['C_KEY']
  config.consumer_secret    = ENV['CS_KEY']
  config.oauth_token        = ENV['OA_TOKEN']
  config.oauth_token_secret = ENV['OAS_TOKEN']
end

TweetStream.configure do |config|
  config.consumer_key       = ENV['C_KEY']
  config.consumer_secret    = ENV['CS_KEY']
  config.oauth_token        = ENV['OA_TOKEN']
  config.oauth_token_secret = ENV['OAS_TOKEN']
  config.auth_method        = :oauth
end

run GeorgeFolio::MyApp

