require 'spec_helper'

describe "User" do
  before(:each) do
    @user = FactoryGirl.create(:user)
  end

  it 'should return correct user attributes' do
    expect(@user.email).to eql('jondoe@apple.com')
  end

  it 'should encrypt password' do
    expect(@user.hashed_password).to eql(Digest::SHA1.hexdigest(@user.password))
  end
end