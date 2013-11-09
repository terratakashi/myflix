class User < ActiveRecord::Base
  has_secure_password validations: false
  has_many :reviews, ->{ order('created_at DESC') }
  has_many :queue_items, ->{ order(:position) }
  has_many :following_relationships, class_name: "Relationship",foreign_key: "follower_id"
  has_many :leading_relationships, class_name: "Relationship",foreign_key: "leader_id"

  validates :full_name, :presence => true
  validates :email, :presence => true, :uniqueness => true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/}
  validates :password, :presence => true, on: :create


  def normalize_queue_item_position
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index + 1)
    end
  end

  def queued_video?(video)
    queue_items.map(&:video).include?(video)
  end

  def following?(leader)
    following_relationships.map(&:leader).include?(leader)
  end

  def can_follow?(another_user)
    !(self.following?(another_user) || self == another_user)
  end
end
