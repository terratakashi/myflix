class User < ActiveRecord::Base
  has_secure_password

  validates :full_name, :presence => true
  validates :email, :presence => true
  validates :email, :uniqueness => true
  validates :password, :presence => true, on: :create
  validates :password_confirmation, :presence => true, on: :create
end
