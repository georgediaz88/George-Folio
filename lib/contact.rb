class Contact
  include ActiveAttr::Model
  include ActiveAttr::MassAssignment

  attribute :name
  attribute :email
  attribute :description

  validates_presence_of :name, message: 'cant be blank'
  validates_presence_of :email, message: 'cant be blank'
  validates_presence_of :description, message: 'cant be blank'
end