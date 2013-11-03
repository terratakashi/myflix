require "spec_helper"

describe SessionsController do
  describe "GET #new" do
    it "redirects to home page for authenticated users" do
      set_current_user

      get :new
      expect(response).to redirect_to home_path
    end

    it "render new template for unauthenticated users" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    context "with valid credentails" do
      before do
        user = Fabricate(:user)
        post :create, email: user.email, password: user.password
      end

      it "puts the user id into the session" do
        user = User.first
        expect(session[:user_id]).to eq(user.id)
      end

      it "redirects to home page" do
        expect(response).to redirect_to home_path
      end
      it "sets the notice" do
        expect(flash[:notice]).not_to be_blank
      end
    end

    context "with invalid credentails" do
      before do
        user = Fabricate(:user)
        post :create, email: user.email, password: "wrong_password"
      end

      it "doesn't put the user id into the session" do
        expect(session[:user_id]).to be_nil
      end

      it "redirects to sign in page" do
        expect(response).to redirect_to sign_in_path
      end
      it "sets the error message" do
        expect(flash[:error]).not_to be_blank
      end
    end
  end

  describe "GET #destroy" do
    before do
      set_current_user
      get :destroy
    end

    it "sets session to nil" do
      expect(session[:user_id]).to be_nil
    end

    it "redirects to root page" do
      expect(response).to redirect_to root_path
    end

    it "sets the notice" do
      expect(flash[:notice]).not_to be_blank
    end
  end
end
