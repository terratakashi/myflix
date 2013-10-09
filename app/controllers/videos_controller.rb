class VideosController < ApplicationController

  def home
    @categories = Category.includes(:videos).all
  end

  def show
    @video = Video.find(params[:id])
  end

end