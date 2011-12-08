configure :development do
  DataMapper.setup(:default, {
    :adapter  => 'mysql',
    :host     => 'localhost',
    :username => 'root' ,
    :password => '',
    :database => 'portfolio_development'})
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL']) #used by Heroku
end