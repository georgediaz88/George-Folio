require 'digest/sha1'

class User
  include Mongoid::Document
  attr_accessor :password

  field :email, type: String
  field :hashed_password, type: String

  validates :email, presence: true

  # Callbacks:
  before_save :encrypt_password

  def encrypt_password
    unless self.password.blank?
     self.hashed_password = Digest::SHA1.hexdigest(self.password)
    end
  end
end