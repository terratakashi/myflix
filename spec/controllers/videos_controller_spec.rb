require "spec_helper"
describe VideosController do

  describe "GET #show" do
    it "sets @video for authenticated users" do
      set_current_user
      video = Fabricate(:video)
      # test show action
      get :show, id: video
      expect(assigns(:video)).to eq(video)
    end

    it "sets @reviews for authenticated users" do
      set_current_user
      video = Fabricate(:video)
      review1 = Fabricate(:review, video: video, user: current_user)
      review2 = Fabricate(:review, video: video, user: current_user)
      # test show action
      get :show, id: video
      expect(assigns(:reviews)).to match_array([review1, review2])
    end

    it_behaves_like "requires sign in" do
        let(:action) { get :show, id: 1 }
    end
  end

  describe "POST #search" do
    it "sets @videos for authenticated users" do
      set_current_user
      batman = Video.create(:title => "batman", :description => "a real hero")
      #test search action
      post :search, query: "atma"
      expect(assigns(:videos)).to eq [batman]
    end

    it_behaves_like "requires sign in" do
        let(:action) { post :search, query: "atma" }
    end
  end
end
