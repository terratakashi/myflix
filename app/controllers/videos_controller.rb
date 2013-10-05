class VideosController < ApplicationController

  def home
    @videos = Video.all.limit(6)
  end

  def show
    @video = Video.find(params[:id])
  end

end