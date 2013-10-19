class ReviewsController < ApplicationController
  before_action :require_user

  def create
    @video = Video.find(params[:video_id])
    @review = @video.reviews.new( secure_params.merge!(user: current_user) )
    if @review.save
      flash[:notice] = "The review has been created!"
      redirect_to @video
    else
      @reviews = @video.reviews.reload
      render "videos/show"
    end
  end

  private

  def secure_params
    params.require(:review).permit(:rating, :content)
  end
end
