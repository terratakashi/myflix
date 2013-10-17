class User < ActiveRecord::Base
  has_secure_password validations: false

  validates :full_name, :presence => true
  validates :email, :presence => true, :uniqueness => true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/}
  validates :password, :presence => true, on: :create
end
