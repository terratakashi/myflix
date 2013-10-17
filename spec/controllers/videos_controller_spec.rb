require "spec_helper"
describe VideosController do

  describe "GET #show" do
    it "sets @video for authenticated users" do
      bruce = User.create(full_name: "Bruce Chen", email: "bruce@kongfu.com", password: 'password')
      session[:user_id] = bruce.id
      batman = Video.create(:title => "batman", :description => "a real hero")
      # test show action
      get :show, id: batman
      expect(assigns(:video)).to eq(batman)
    end

    it "redirect to sign in page for unauthenticated users" do
      batman = Video.create(:title => "batman", :description => "a real hero")
      # test show action
      get :show, id: batman
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "POST search" do
    it "sets @videos for authenticated users" do
      bruce = User.create(full_name: "Bruce Chen", email: "bruce@kongfu.com", password: 'password')
      session[:user_id] = bruce.id
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
