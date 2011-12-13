#LoadGems
require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'haml'
require 'sass'
require 'pony'

%w{
  /config/email_defaults
  /app
  }.each {|file| require File.dirname(__FILE__) + file }

ENV['RACK_ENV'] ||= "development"
Bundler.require(:default, (ENV['RACK_ENV'].to_sym))

set :run, false
set :raise_errors, true
#set :views, Proc.new { File.join(root, "templates") }

run MyApp

