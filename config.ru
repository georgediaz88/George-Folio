#LoadGems
require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'haml'
require 'sass'
require 'pony'
require 'data_mapper'


# need install dm-sqlite-adapter
DataMapper::setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/mysite.db")

class GmailAccount
    include DataMapper::Resource
    property :id, Serial
    property :username, String
    property :password, String
end

# automatically create the post table
GmailAccount.auto_migrate! unless GmailAccount.storage_exists?

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

