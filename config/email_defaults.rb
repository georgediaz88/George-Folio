#setup email defaults here --> smtp settings for gmail:
signin_obj = GmailAccount.first
Pony.options = { :from => signin_obj.username, :via => :smtp, 
                 :via_options => {  :address => 'smtp.gmail.com',
                                    :port => '587',
                                    :enable_starttls_auto => true,
                                    :user_name => signin_obj.username,
                                    :password =>  signin_obj.password,
                                    :authentication => :plain,
                                    :domain => "HELO" } 
                }