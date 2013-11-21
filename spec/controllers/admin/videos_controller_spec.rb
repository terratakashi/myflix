require "spec_helper"

describe Admin::VideosController do
  describe "GET #new" do
    it_behaves_like "requires sign in" do
      let(:action) {get :new}
    end

    it_behaves_like "requires admin" do
      let(:action) {get :new}
    end

    it "sets @video to be a new video" do
      set_current_admin
      get :new
      expect(assigns(:video)).to be_instance_of(Video)
      expect(assigns(:video)).to be_new_record
    end
  end

  describe "POST #create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create, video: {title: "batman", description: "cool", category_ids:["1"]} }
    end

    it_behaves_like "requires admin" do
      let(:action) { post :create, video: {title: "batman", description: "cool", category_ids:["1"]} }
    end

    before { set_current_admin }

    context "with valid input" do
      it "creates a video" do
        post :create, video: {title: "batman", description: "cool"}
        expect(Video.count).to eq(1)
      end

      it "redirects to new video page" do
        post :create, video: {title: "batman", description: "cool"}
        video = Video.find_by_title("batman")
        expect(response).to redirect_to new_admin_video_path
      end

      it "create a video associated with some categories" do
        category1 = Fabricate(:category)
        category2 = Fabricate(:category)
        post :create, video: {title: "batman", description: "cool", category_ids:["1", "2"]}
        video = Video.find_by_title("batman")
        expect(video.categories).to match_array([category1, category2])
      end

      it "set a success message" do
        Fabricate(:category)
        post :create, video: {title: "batman", description: "cool", category_ids:["1"]}
        expect(flash[:notice]).to be_present
      end
    end

    context "with invalid input" do
      it "render the :new template" do
        post :create, video: {title: "batman"}
        expect(response).to render_template :new
      end

      it "does not create a video" do
        post :create, video: {title: "batman"}
        expect(Video.count).to eq(0)
      end

      it "sets @video variable" do
        post :create, video: {title: "batman"}
        expect(assigns(:video).title).to eq("batman")
      end

      it "sets a error message" do
        post :create, video: {title: "batman"}
        expect(flash[:error]).to be_present
      end
    end
  end
end
