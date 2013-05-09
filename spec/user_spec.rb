require 'spec_helper'

describe "User" do
  before(:each) do
    @user = FactoryGirl.create(:user)
  end

  it 'should return correct user attributes' do
    @user.email.should eql('jondoe@apple.com')
    @user.stub(:hashed_password).and_return('pass_encrypted')
    @user.hashed_password.should eql('pass_encrypted')
  end

  it 'should encrypt password' do
    @user.hashed_password.should_not be_nil
  end
end