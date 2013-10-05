class VideosController < ApplicationController

  def home
    @categories = Category.includes(:videos).limit(6).references(:videos).all
  end

  def show
    @video = Video.find(params[:id])
  end

end