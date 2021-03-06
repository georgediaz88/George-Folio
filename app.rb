%w(sinatra mongoid pony active_attr redis eventmachine).each{|g| require g}

module GeorgeFolio
  class MyApp < Sinatra::Base

    configure do
      Mongoid.load!('config/mongoid.yml')
      %w{config/email_defaults lib/user lib/contact lib/tweet lib/application_helper}.each {|ext| require "#{File.dirname(__FILE__)}/#{ext}" }
      redis_url = ENV['REDISTOGO_URL'] || 'redis://localhost:6379/'
      uri = URI.parse(redis_url)
      $redis = Redis.new(host: uri.host, port: uri.port, password: uri.password)
      use Rack::CommonLogger
    end

    configure(:development, :production) do
      EM.next_tick do
        @cli = TweetStream::Client.new
        @cli.follow(59949265, :delete => Proc.new {|status_id, usr_id| Tweet.remove!(status_id, usr_id)}) do |status|
          stored_txt = "#{status.text}PipeTweetPipe#{status.source}PipeTweetPipe#{status.id}"
          $redis.lpush 'my_tweets', stored_txt
        end
      end
    end

    helpers do
      include ApplicationHelper
      include TwitterMethods
    end

    ######### re-route for sass / possibly coffeescript?
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
      #Temp Hack 4heroku: $redis.del 'my_tweets'
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
        Pony.mail  to: 'georgediaz88@gmail.com',
                   subject: "Message Sent From #{@contact.name}",
                   body: "#{@contact.description} --- sent from #{@contact.email}"
        haml :receipt_email #Show User Thank You Template
      else
        redirect '/contact_me'
      end
    end

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

  end
end
