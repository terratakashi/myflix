class VideosController < ApplicationController
  before_action :require_user

  def index
    @categories = Category.includes(:videos).all
  end

  def show
    @video = Video.find(params[:id])
    @reviews = @video.reviews
  end

  def search
    @keywords = params[:query]
    @videos = Video.search_by_title(@keywords)
  end

end
