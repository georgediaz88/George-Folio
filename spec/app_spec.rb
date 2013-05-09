require 'spec_helper'

describe "My Sites Pages" do
  before(:each) do
    Twitter.stub(:configure => true)
    Twitter.stub(:user_timeline => [])
  end

  it "should respond successfuly to homepage" do
    get '/'
    last_response.should be_ok
  end

  it "should persist homepage text name" do
    get '/'
    last_response.body.should match(/George's Portfolio/)
  end

  it "should see About Me on Top" do
    get '/about_me'
    last_response.body.should match(/About Me/)
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
  before(:each) do
    Pony.stub!(:deliver)
  end

  it "sends mail" do
    Pony.should_receive(:deliver) do |mail|
      mail.to.should == [ 'test@test.com' ]
      mail.from.should == [ 'me@test.com' ]
      mail.subject.should == 'hi'
      mail.body.should == 'Hello World!'
    end


    Pony.mail  to: 'test@test.com',
               from: 'me@test.com',
               subject: 'hi',
               body: 'Hello World!'
  end

  it 'should allow contact me form to submit to email and redirect to thank you page' do
    visit '/contact_me'
    fill_in 'contact[name]', :with => 'Jon Doe'
    fill_in 'contact[email]', :with => 'test@test.com'
    fill_in 'contact[description]', :with => 'Hello World!'
    click_button 'Send'
    page.should have_content('THANKS FOR YOUR EMAIL')
  end

  it "requires :to paramater to be initialized" do
    lambda { Pony.mail({}) }.should raise_error(ArgumentError)
  end
end
