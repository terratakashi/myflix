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
end
