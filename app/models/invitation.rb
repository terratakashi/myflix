# module Tokenable located at app/lib/tokenable.rb
require_relative "../../lib/tokenable.rb"

class Invitation < ActiveRecord::Base
  include Tokenable
  belongs_to :inviter, class_name: "User"

  validates :recipient_name, presence: true
  validates :recipient_email, presence: true
  validates :message, presence: true
end
