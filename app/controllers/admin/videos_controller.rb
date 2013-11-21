class Admin::VideosController < AdminController
  def new
    @video = Video.new
  end

  def create
    @video = Video.new(secure_params)
    if @video.save
      flash[:notice] = "The video #{@video.title} has been created successfully!"
      redirect_to new_admin_video_path
    else
      flash[:error] = "Invalid inputs for a video, please check!"
      render :new
    end
  end

  private

  def secure_params
    params.require(:video).permit(:title, :description, :small_cover, :large_cover, category_ids: [])
  end
end
