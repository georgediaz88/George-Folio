task :push do
  puts "Beginning Push to Git/Heroku ..."
  %x{git push origin master && git push heroku master}
  puts "Completed Push to Git/Heroku ..."
end