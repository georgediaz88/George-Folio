#LoadGems
require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'haml'
require 'sass'
require 'pony'

require File.dirname(__FILE__) + '/config/email_defaults'
require File.dirname(__FILE__) + '/app'

ENV['RACK_ENV'] ||= "development"
Bundler.require(:default, (ENV['RACK_ENV'].to_sym))

set :run, false
set :raise_errors, true
#set :views, Proc.new { File.join(root, "templates") }

run MyApp