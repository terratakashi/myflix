class User < ActiveRecord::Base
  has_secure_password

  validates :full_name, :presence => true
  validates :email, :presence => true
end
