#LoadGems
require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'pony'
require 'data_mapper'

require File.join(File.dirname(__FILE__), 'app')

ENV['RACK_ENV'] ||= "development"
Bundler.require(:default, (ENV['RACK_ENV'].to_sym))

set :run, false
set :raise_errors, true
#set :views, Proc.new { File.join(root, "templates") }

#DataMapper.setup(:default, ENV["SHARED_DATABASE_URL"] || "sqlite3://#{Dir.pwd}/folio.db")
#DataMapper.finalize.auto_upgrade! #Tells Datamapper to automaticly update the database with changes made

run GeorgeFolio::MyApp

