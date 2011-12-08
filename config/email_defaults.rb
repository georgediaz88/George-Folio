#Model
class EmailAccount
  include DataMapper::Resource
  property :id, Serial
  property :username, String
  property :password, String
end

EmailAccount.auto_migrate! unless EmailAccount.storage_exists?

#setup email defaults here --> smtp settings for gmail:
account = EmailAccount.first
username = account.username
pwd = account.password
Pony.options = { :from => username, :via => :smtp, 
                 :via_options => {  :address => 'smtp.gmail.com',
                                    :port => '587',
                                    :enable_starttls_auto => true,
                                    :user_name => username,
                                    :password => pwd,
                                    :authentication => :plain,
                                    :domain => "HELO" } 
                }