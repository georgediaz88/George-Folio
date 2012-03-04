require 'digest/sha1'

class User

  attr_accessor :password

  include DataMapper::Resource
  property :id, Serial
  property :email, Text, :required => true
  property :hashed_password, Text #, :default => false
  
  before :save, :encrypt_password

  def encrypt_password
    unless self.password.blank?
     self.hashed_password = Digest::SHA1.hexdigest(self.password)
    end
  end

end

class Contact #Todo: move to sep. file
  include ActiveAttr::Model
  include ActiveAttr::MassAssignment
  
  attribute :name
  attribute :email
  attribute :description
  
  validates_presence_of :name, message: 'cant be blank'
  validates_presence_of :email, message: 'cant be blank'
end