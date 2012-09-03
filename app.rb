require 'pony'
require 'data_mapper'
require 'redis'
require 'uri'

module GeorgeFolio
  class MyApp < Sinatra::Base

    configure do
      %w{ /config/email_defaults /lib/user /lib/contact }.each {|file| require File.dirname(__FILE__) + file }
      redis_url = ENV["REDISTOGO_URL"] || 'redis://localhost:6379/'
      uri = URI.parse(redis_url)
      $redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
    end
    
    configure(:development,:production) do
      DataMapper.setup(:default, ENV["DATABASE_URL"] || "sqlite3://#{Dir.pwd}/folio.db")
      DataMapper.finalize.auto_upgrade! #Tells Datamapper to automaticly update the database with changes made
    end

    helpers do
      load("./lib/application_helper.rb")
      include ApplicationHelper
    end

    ######### re-route for sass / possibly coffee?
    get '/css/*.css' do
      file_name = params[:splat].first
      file_path = "../public/css/#{file_name}"
      scss "#{file_path}".to_sym
    end

    # get '/application.js' do
    #   coffee :'javascripts/application'
    # end

    #####################################

    #HTTP calls
    get '/' do
      @latest_tweets = []
      fetch_tweets_if_needed
      tweet_objects = $redis.lrange 'my_tweets', 0, 1
      parse_from_redis(tweet_objects)
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
      @title   = 'Contact Me'
      @contact = Contact.new(name: params[:name], email: params[:email], description: params[:description])
      haml :contact_me
    end

    post '/send_email' do
      @contact = Contact.new(params[:contact])
      if @contact.valid?
        Pony.mail  to: 'georgediaz88@yahoo.com',
                   subject: "Message Sent From #{@contact.name}",
                   body: "#{@contact.description} --- sent from #{@contact.email}"
        haml :receipt_email #Show User Thank You Template
      else
        # haml :contact_me
        redirect '/contact_me'
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
    
    protected
    
    def fetch_tweets_if_needed
      unless $redis.llen('my_tweets') > 1
        tweets = Twitter.user_timeline(count: 2)
        tweets.reverse.each {|tweet| $redis.lpush 'my_tweets', "#{tweet.text}PipeTweetPipe#{tweet.source}"}
        $redis.expire 'my_tweets', 60*15
      end
    end

    def parse_from_redis(tweet_objects)
      tweet_objects.each do |tweet_obj|
        parsed_tweet = tweet_obj.split('PipeTweetPipe')
        text, source = parsed_tweet[0], parsed_tweet[1]
        @latest_tweets << {:text => text, :source => source}
      end
    end

  end
end

