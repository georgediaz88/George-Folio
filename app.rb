require 'pony'
require 'data_mapper'
require 'barista'

module GeorgeFolio
  class MyApp < Sinatra::Base

    configure do
      register Barista::Integration::Sinatra
      %w{ /config/email_defaults /lib/user /lib/contact }.each {|file| require File.dirname(__FILE__) + file }
    end
    
    configure(:development,:production) do
      DataMapper.setup(:default, ENV["DATABASE_URL"] || "sqlite3://#{Dir.pwd}/folio.db")
      DataMapper.finalize.auto_upgrade! #Tells Datamapper to automaticly update the database with changes made
    end

    helpers do
      load("./lib/application_helper.rb")
      include ApplicationHelper
    end

    ######### re-route to sass and coffee
    get '/style.css' do
      scss :'css/style'
    end
    
    get '/application.js' do
      coffee :'javascripts/application'
    end
    #####################################

    #HTTP calls
    get '/' do
      @last_tweet = Twitter.user_timeline.first
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
      @contact = Contact.new(name: params[:name], email: params[:email], description: params[:description])
      if @contact.valid?
        Pony.mail  to: 'georgediaz88@yahoo.com',
                   subject: "Message Sent From #{@contact.name}",
                   body: "#{@contact.description} --- sent from #{@contact.email}"
        haml :receipt_email #Show User Thank You Template
      else
        @msg1 = @contact.errors[:name][0]
        @msg2 = @contact.errors[:email][0]
        @msg3 = @contact.errors[:description][0]
        haml :contact_me
      end
    end

    ######### Tweet Section ##########
    get '/tweet' do
      protected!
      haml :tweet
    end

    post '/post_tweet' do
      if params['status'].blank?
        redirect '/tweet'
      else
        Twitter.update(params['status'])
        redirect '/'
      end
    end
    ###################################

  end
end


