require 'pony'
require 'data_mapper'

module GeorgeFolio
  class MyApp < Sinatra::Base

    configure do
      register Barista::Integration::Sinatra
      %w{ /config/email_defaults /lib/user }.each {|file| require File.dirname(__FILE__) + file }      
    end
    
    configure(:development,:production) do
      DataMapper.setup(:default, ENV["DATABASE_URL"] || "sqlite3://#{Dir.pwd}/folio.db")
      DataMapper.finalize.auto_upgrade! #Tells Datamapper to automaticly update the database with changes made
    end

    helpers do
      load("./lib/application_helper.rb")
      include ApplicationHelper
    end

    ######### re-route css to sass templating
    get '/style.css' do
      scss :'css/style'
    end
    
    get '/application.js' do
      coffee :'javascripts/application'
    end
    #########################################

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

      @mssg1 = 'cant be blank' if params[:e1] #name error
      @mssg2 = 'cant be blank' if params[:e2] #email error

      haml :contact_me
    end

    post '/send_email' do
      @name, @email, @description = params[:name], params[:email], params[:description] #params retrieved from form
      
      if @name.blank? && @email.blank?
        redirect to('/contact_me?e1=t&e2=t')
      elsif @name.blank? || @email.blank?
        params_to = '?'
        params_to << 'e1=t' if @name.blank?
        params_to << 'e2=t' if @email.blank?
        redirect to("/contact_me#{params_to}")
      else
        Pony.mail  to: 'georgediaz88@yahoo.com',
                   subject: "Message Sent From #{@name}",
                   body: "#{@description} --- sent from #{@email}"
        haml :receipt_email #Show User Thank You Template
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


