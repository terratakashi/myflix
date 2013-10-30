class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates :position, numericality: { only_integer: true }

  delegate :categories, to: :video
  delegate :title, to: :video, prefix: :video

  def rating
    review = Review.where(video: video, user: user).first
    review.rating if review
  end
end
