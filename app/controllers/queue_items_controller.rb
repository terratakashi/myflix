class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])

    if new_queue_item?(video)
      QueueItem.create(video: video, user: current_user, position: new_queue_item_position)
      flash[:notice] = "#{video.title} has been added to my queue."
    else
      flash[:warning] = "#{video.title} is already in my queue."
    end

    redirect_to my_queue_path
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    queue_item.destroy if queue_item.user == current_user
    current_user.normalize_queue_item_position
    redirect_to my_queue_path
  end

  def update_queue
    begin
      update_queue_items
      current_user.normalize_queue_item_position
    rescue ActiveRecord::RecordInvalid
      flash[:error] = "Invalid position number!"
    end
    redirect_to my_queue_path
  end

  private

  def new_queue_item_position
    current_user.queue_items.count + 1
  end

  def new_queue_item?(video)
    !current_user.queue_items.map(&:video).include?(video)
  end

  def update_queue_items
    ActiveRecord::Base.transaction do
      params[:queue_items].each do |queue_item_data|
        queue_item = QueueItem.find(queue_item_data[:id])
        if queue_item.user == current_user
          queue_item.update_attributes!(position: queue_item_data[:position])
        end
      end
    end
  end
end
