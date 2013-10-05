class Category < ActiveRecord::Base
  has_many :categories_videos
  has_many :videos, :through => :categories_videos
end