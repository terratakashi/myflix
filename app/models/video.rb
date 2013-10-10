class Video < ActiveRecord::Base
  has_many :categories_videos
  has_many :categories, :through => :categories_videos   

  validates :title, :presence => true
  validates :description, :presence => true, :length =>{:maximum => 1000}
end