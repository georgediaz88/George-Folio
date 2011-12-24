require 'spec_helper'

describe "My Sites Pages" do

  it "should respond successfuly to homepage" do
    get '/'
    last_response.should be_ok
  end
  
  it "should persist homepage text name" do
    get '/'
    last_response.body.should match(/George's Portfolio/)
  end
  
  it "should respond successfuly to About Me page" do
    get '/about_me'
    last_response.should be_ok
  end
  
  it "should respond successfuly to My Work page" do
    get '/my_work'
    last_response.should be_ok
  end
  
  it "should respond successfuly to Contact Me page" do
    get '/contact_me'
    last_response.status.should ==  200 # this is alternate to be_ok
  end
  
  ##TODO: Test Email Feature through Pony

end