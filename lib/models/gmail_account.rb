DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")
class GmailAccount
  include DataMapper::Resource  
  property :id,           Serial
  property :username,     String
  property :password,     String
end

DataMapper.auto_upgrade!