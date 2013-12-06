class Video < ActiveRecord::Base
  has_many :categories_videos
  has_many :categories, :through => :categories_videos
  has_many :reviews, ->{ order('created_at DESC') }

  validates :title, :presence => true
  validates :description, :presence => true, :length =>{:maximum => 1000}

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  def self.search_by_title(keywords)
    if !keywords.blank?
      keywords = keywords.split
      query = keywords.map { |keyword| "title like '%#{keyword}%'"}.join(" OR ")
      where(query).order(created_at: :desc)
    end
  end

  def decorate
    VideoDecorator.new(self)
  end

  def average_rating
    reviews.average("rating").round(1) if reviews.average("rating")
  end
end
