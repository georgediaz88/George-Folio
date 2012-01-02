#add required files below
require 'pony'
require 'data_mapper'

%w{ /config/email_defaults }.each {|file| require File.dirname(__FILE__) + file }

module GeorgeFolio
  class MyApp < Sinatra::Base

    ######### re-route css to sass templating
    get '/style.css' do
      scss :'css/style'
    end
    #########################################
    
    ####DB Setup: TODO -> Move to a file
    
    #DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/movies.db") #setting up new database name movies.db
    DataMapper.setup(:default, ENV["DATABASE_URL"] || "sqlite3://#{Dir.pwd}/folio.db")

    class User #DataMapper creates table
      include DataMapper::Resource
      property :id, Serial
      property :email, Text, :required => true
      property :hashed_password, Text, :required => true #, :default => false
    end

    DataMapper.finalize.auto_upgrade! #Tells Datamapper to automaticly update the database with changes made

    #HTTP calls
    get '/' do
      haml :index
    end

    get '/about_me' do
      @title = 'About Me'
      haml :about_me
    end

    get '/my_work' do
      @title = 'My Work'
      haml :my_work
    end

    get '/contact_me' do
      @title = 'Contact Me'
      haml :contact_me
    end

    post '/send_email' do
      @name, @email, @description = params[:name], params[:email], params[:description] #params retrieved from form
      if (@name.empty? || @email.empty?)
        redirect '/contact_me'
      else
        Pony.mail  :to => 'georgediaz88@yahoo.com',
                   :subject => "Message Sent From #{@name}",
                   :body => "#{@description} --- sent from #{@email}"
        haml :receipt_email #Show User Thank You Template
      end
    end

  end
end


