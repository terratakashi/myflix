class Category < ActiveRecord::Base
  has_many :categories_videos
  has_many :videos, ->{ order('created_at DESC') }, :through => :categories_videos

  validates :name, :presence => true, :uniqueness => true

  def recent_videos
    videos = self.videos.first(6)
  end

end
