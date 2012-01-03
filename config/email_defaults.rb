#setup email defaults here --> smtp settings for gmail:
Pony.options = { :from => 'allrecipefavorites@gmail.com', :via => :smtp, 
                 :via_options => {  :address => 'smtp.gmail.com',
                                    :port => '587',
                                    :enable_starttls_auto => true,
                                    :user_name => ENV['GMAIL_USERNAME'],
                                    :password =>  ENV['GMAIL_PSWD'],
                                    :authentication => :plain,
                                    :domain => "HELO" } 
                }