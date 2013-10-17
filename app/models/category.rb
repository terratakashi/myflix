class Category < ActiveRecord::Base
  has_many :categories_videos
  has_many :videos, :through => :categories_videos, :order => "created_at DESC"

  validates :name, :presence => true, :uniqueness => true

  def recent_videos
    videos = self.videos.first(6)
  end

end
