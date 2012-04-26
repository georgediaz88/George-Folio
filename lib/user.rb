require 'digest/sha1'

class User

  attr_accessor :password

  include DataMapper::Resource
  property :id, Serial
  property :email, Text, required:true
  property :hashed_password, Text #, default: true
  
  before :save, :encrypt_password

  def encrypt_password
    unless self.password.blank?
     self.hashed_password = Digest::SHA1.hexdigest(self.password)
    end
  end

end