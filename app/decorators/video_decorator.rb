class VideoDecorator < Draper::Decorator
  delegate_all

  def average_rating
    if object.average_rating.present?
      "#{object.average_rating}/5.0"
    else
      "N/A"
    end
  end
end
