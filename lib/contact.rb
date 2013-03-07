class Contact
  include Mongoid::Document

  field :name, type: String
  field :email, type: String
  field :description, type: String

  validates :name, presence: true
  validates :email, presence: true
  validates :description, presence: true
end