require "spec_helper"
describe VideosController do

  describe "GET #show" do
    it "sets @video for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      # test show action
      get :show, id: video
      expect(assigns(:video)).to eq(video)
    end

    it "redirect to sign in page for unauthenticated users" do
      video = Fabricate(:video)
      # test show action
      get :show, id: video
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "POST #search" do
    it "sets @videos for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      batman = Video.create(:title => "batman", :description => "a real hero")
      #test search action
      post :search, query: "atma"
      expect(assigns(:videos)).to eq [batman]
    end

    it "redirect to sign in page for unauthenticated users" do
      batman = Video.create(:title => "batman", :description => "a real hero")
      # test show action
      post :search, query: "atma"
      expect(response).to redirect_to sign_in_path
    end
  end
end
