class VideosController < ApplicationController

  def index
    @categories = Category.includes(:videos).all
  end

  def show
    @video = Video.find(params[:id])
  end

  def search
    @keywords = params[:query]
    @videos = Video.search_by_title(@keywords)
  end

end
