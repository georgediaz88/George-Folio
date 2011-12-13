class GmailAccount
  include DataMapper::Resource  
  property :id,           Serial
  property :username,     String
  property :password,     String
end

DataMapper.auto_upgrade!