require 'spec_helper'

describe ReviewsController do
  describe "POST #create" do
    let(:video) { Fabricate(:video) }

    context "with authenticated users" do
      let(:user) { Fabricate(:user) }
      before { session[:user_id] = user.id }

      context "with valid input" do
        before { post :create, review: Fabricate.attributes_for(:review), video_id: video, user: user }

        it "sets the @video" do
          expect(assigns(:video)).to eq(video)
        end

        it "redirect to video" do
          expect(response).to redirect_to video
        end

        it "create the @review" do
          expect(Review.count).to eq(1)
        end

        it "create the @review associated with sign in user" do
          expect(Review.first.user).to eq(user)
        end

        it "create the @review associated with video" do
          expect(Review.first.video).to eq(video)
        end

        it "sets the notice" do
          expect(flash[:notice]).not_to be_blank
        end
      end

      context "with invalid intput" do
        it "doesn't create review" do
          post :create, review: {rating: 3}, video_id: video, user: user
          expect(Review.count).to eq(0)
        end

        it "render videos/show template" do
          post :create, review: {rating: 3}, video_id: video, user: user
          expect(response).to render_template "videos/show"
        end

        it "sets @video" do
          post :create, review: {rating: 3}, video_id: video, user: user
          expect(assigns(:video)).to eq(video)
        end

        it "sets @reviews" do
          review = Fabricate(:review, video: video)
          post :create, review: {rating: 3}, video_id: video, user: user
          expect(assigns(:reviews)).to match_array([review])
        end
      end
    end

    context "with unauthenticated users" do
      it "redirect to root page" do
        post :create, review: Fabricate.attributes_for(:review), video_id: video
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end
