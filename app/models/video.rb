class Video < ActiveRecord::Base
  has_many :categories_videos
  has_many :categories, :through => :categories_videos   

  validates :title, :presence => true
  validates :description, :presence => true, :length =>{:maximum => 1000}

  def self.search_by_title(keywords)
    if !keywords.blank?
      keywords = keywords.split
      query = keywords.map { |keyword| "title like '%#{keyword}%'"}.join(" OR ")
      where(query)
    end
  end
end