require 'spec_helper'

describe "My Sites Pages" do

  it "should respond successfuly to homepage" do
    pending("Research Twitter API call")
    get '/'
    last_response.should be_ok
  end
  
  it "should persist homepage text name" do
    pending("Dependent on Twitter Fix")
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
    last_response.status.should eql(200) # this is alternate to be_ok
  end

end

describe "Test Email Feature" do

  before(:all) do
    Pony.stub!(:deliver)
  end
  
  it "sends mail" do
    Pony.should_receive(:deliver) do |mail|
      mail.to.should == [ 'test@test.com' ]
      mail.from.should == [ 'me@test.com' ]
      mail.subject.should == 'hi'
      mail.body.should == 'Hello World!'
    end
    Pony.mail(:to => 'test@test.com', :from => 'me@test.com', :subject => 'hi', :body => 'Hello World!')
  end
  
  it "requires :to paramater to be initialized" do
    lambda { Pony.mail({}) }.should raise_error(ArgumentError)
  end

end

describe "User" do
  before(:each) do 
    @user = User.create(:email => 'jondoe@apple.com', :password => 'pass')
      #think of replacing w/ Fabricator or FactorGirl
  end
  
  it "should return user attributes" do
    @user.email.should eql('jondoe@apple.com')
    @user.stub(:hashed_password).and_return('pass_encrypted')
    @user.hashed_password.should eql('pass_encrypted')
  end
end

