class Category < ActiveRecord::Base
  has_many :categories_videos
  has_many :videos, :through => :categories_videos

  validates :name, :presence => true, :uniqueness => true
end