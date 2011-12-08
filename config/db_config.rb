configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL']) #used by Heroku
end