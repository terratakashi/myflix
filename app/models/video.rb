class Video < ActiveRecord::Base
  has_many :categories_videos
  has_many :categories, :through => :categories_videos   
end