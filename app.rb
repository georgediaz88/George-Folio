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
      
      EM.schedule do
        TweetStream::Client.new.follow(59949265) do |status|
          stored_txt = "#{status.text}PipeTweetPipe#{status.source}PipeTweetPipe#{status.id}"
          $redis.lpush 'my_tweets', stored_txt
        end
      end
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
      if $redis.llen('my_tweets') < 1 or $redis.llen('my_tweets') > 8 #reload tweets
        $redis.del 'my_tweets'
        tweets = Twitter.user_timeline(count: 2)
        tweets.reverse.each do |tweet| 
          $redis.lpush 'my_tweets', "#{tweet.text}PipeTweetPipe#{tweet.source}PipeTweetPipe#{tweet.id}"
        end
        # $redis.expire 'my_tweets', 60*15
      end
    end

    def parse_from_redis(tweet_objects)
      tweet_objects.each do |tweet_obj|
        parsed_tweet = tweet_obj.split('PipeTweetPipe')
        text, source = parsed_tweet[0], parsed_tweet[1]
        @latest_tweets << {:text => text, :source => source}
        #Note: parsed_tweet[2] is status_id
      end
    end

  end
end

#puts 'start EM scheduler'
# @cli.on_delete do |status_id, user_id|
#   handle deleting status_id if in redis
# end
# ============ 
#   TweetStream::Client.new(TWITTER_USERNAME, TWITTER_PASSWORD).on_delete do |status_id, user_id|
#     # Tweet.delete(status_id)
#     puts "#{status_id} deleted"
#   end.on_limit do |skip_count|
#     puts "limited, skip count #{skip_count}"
#   end.track('#silviobasta') do |status|
#     puts "[#{status.user.screen_name}] #{status.text}"
#     tweet = { :text => status.text, :user => { :screen_name => status.user.screen_name } }
#     DB['tweets'].insert(tweet)
#     res = Net::HTTP.post_form(URI.parse("http://#{UPDATE_USERNAME}:#{UPDATE_PASSWORD}@silviobasta.heroku.com/update"), tweet)
#   end
#   puts 'end'