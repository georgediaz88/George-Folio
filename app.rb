
module GeorgeFolio
  class MyApp < Sinatra::Base
    
    configure do
      %w{ /config/email_defaults /lib/user }.each {|file| require File.dirname(__FILE__) + file }
    end

    helpers do
      include Rack::Utils
      alias_method :h, :escape_html

      def protected!
        unless authorized?
          response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
          throw(:halt, [401, "Not authorized\n"])
        end
      end

      def authorized?
        @auth ||=  Rack::Auth::Basic::Request.new(request.env)
        @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == [ENV['GMAIL_PSWD'], ENV['GMAIL_PSWD']]
      end
    end

    ######### re-route css to sass templating
    get '/style.css' do
      scss :'css/style'
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
      haml :contact_me
    end

    post '/send_email' do
      @name, @email, @description = params[:name], params[:email], params[:description] #params retrieved from form
      if (@name.blank? || @email.blank?)
        redirect '/contact_me'
      else
        Pony.mail  :to => 'georgediaz88@yahoo.com',
                   :subject => "Message Sent From #{@name}",
                   :body => "#{@description} --- sent from #{@email}"
        haml :receipt_email #Show User Thank You Template
      end
    end

##Tweet
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
#######

  end
end


