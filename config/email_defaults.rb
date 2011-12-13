#setup email defaults here --> smtp settings for gmail:
#signin_obj = GmailAccount.first
Pony.options = { :from => 'allrecipefavorites@gmail.com', :via => :smtp, 
                 :via_options => {  :address => 'smtp.gmail.com',
                                    :port => '587',
                                    :enable_starttls_auto => true,
                                    :user_name => 'allrecipefavorites@gmail.com',#signin_obj.username,
                                    :password => 'recipepassword',#signin_obj.password,
                                    :authentication => :plain,
                                    :domain => "HELO" } 
                }