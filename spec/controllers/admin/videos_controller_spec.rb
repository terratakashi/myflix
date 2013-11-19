require "spec_helper"

describe Admin::VideosController do
  describe "GET #new" do
    it_behaves_like "requires sign in" do
      let(:action) {get :new}
    end

    it "redirects to home page for regular users" do
      set_current_user
      get :new
      expect(response).to redirect_to home_path
    end

    it "sets a error message for regular users" do
      set_current_user
      get :new
      expect(flash[:error]).to be_present
    end

    it "sets @video to be a new video" do
      set_current_admin
      get :new
      expect(assigns(:video)).to be_instance_of(Video)
      expect(assigns(:video)).to be_new_record
    end
  end
end
