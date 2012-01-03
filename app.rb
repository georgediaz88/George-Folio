#require items here ...
%w{ /config/email_defaults /lib/user }.each {|file| require File.dirname(__FILE__) + file }

module GeorgeFolio
  class MyApp < Sinatra::Base

    ######### re-route css to sass templating
    get '/style.css' do
      scss :'css/style'
    end
    #########################################

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
      if (@name.blank? || @email.blank?)
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


