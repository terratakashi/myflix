require "spec_helper"

describe QueueItemsController do
  describe "GET #index" do
    it "sets @queue_items with authenticated users" do
      user = Fabricate(:user)
      session[:user_id] = user
      queue_item1 = Fabricate(:queue_item, user: user)
      queue_item2 = Fabricate(:queue_item, user: user)

      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end
    it "redirect to sign in page with unauthenticated users" do
      get :index
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "POST #create" do
    context "with authenticated users" do
      let(:user) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      before do
        session[:user_id] = user.id
      end

      it "redirect to my queue page" do
        post :create, video_id: video
        expect(response).to redirect_to my_queue_path
      end

      it "sets video variable" do
        post :create, video_id: video
        expect(assigns(:video)).to eq video
      end

      it "create a queue item" do
        post :create, video_id: video
        expect(QueueItem.count).to eq(1)
      end

      it "create a queue item associated with the video" do
        post :create, video_id: video
        expect(QueueItem.first.video).to eq(video)
      end

      it "create a queue item associated with the user" do
        post :create, video_id: video
        expect(QueueItem.first.user).to eq(user)
      end

      it "sets a success notice if add a video to queue success" do
        post :create, video_id: video
        expect(flash[:notice]).not_to be_blank
      end

      it "puts the video as the last one in the queue" do
        queue_item = Fabricate(:queue_item, video: video, user: user)
        second_video = Fabricate(:video)
        post :create, video_id: second_video
        second_video_queue_item = QueueItem.where(video_id: second_video).first
        expect(second_video_queue_item.position).to eq(2)
      end

      it "does not add the video into the queue if the video already exist in the queue" do
        queue_item = Fabricate(:queue_item, video: video, user: user)
        same_video = video
        post :create, video_id: same_video
        expect(QueueItem.count).not_to eq(2)
      end

      it "sets a warning message to the video is already in the queue" do
        queue_item = Fabricate(:queue_item, video: video, user: user)
        same_video = video
        post :create, video_id: same_video
        expect(flash[:warning]).not_to be_blank
      end
    end

    context "with unauthenticated users" do
      it "redirect to sign in page" do
        video = Fabricate(:video)
        post :create, video_id: video
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end
