require "spec_helper"

describe PasswordTokensController do
  describe "post #create" do
    context "with valid user email" do
      it "renders confirm_password_reset page" do
        user = Fabricate(:user)
        post :create, email: user.email
        expect(response).to render_template :confirm_password_reset
      end

      it "sends out a mail" do
        ActionMailer::Base.deliveries.clear
        user = Fabricate(:user)
        post :create, email: user.email
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end

      it "sends out a mail containing a token link" do
        ActionMailer::Base.deliveries.clear
        user = Fabricate(:user)
        post :create, email: user.email
        token = user.reload.token
        expect(ActionMailer::Base.deliveries.last.body).to include(token)
      end
    end

    context "with invalid user email" do
      it "redirects to forgot password page" do
        post :create, email: "alice@example.com"
        expect(response).to redirect_to forgot_password_path
      end

      it "does not send out a mail" do
        ActionMailer::Base.deliveries.clear
        post :create, email: "alice@example.com"
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "set a error message" do
        post :create, email: "alice@example.com"
        expect(flash[:error]).not_to be_blank
      end
    end
  end

  describe "GET #show" do
    it "sets @token" do
      user = Fabricate(:user, token: SecureRandom.urlsafe_base64)
      get :show, id: user.token
      expect(assigns(:token)).to eq(user.token)
    end

    it "renders show template with valid link" do
      user = Fabricate(:user, token: SecureRandom.urlsafe_base64)
      get :show, id: user.token
      expect(response).to render_template :show
    end

    it_behaves_like "requires a valid token" do
      let(:action) { get :show, id: "invalid_token" }
    end
  end

  describe "POST #update" do
    context "with valid token" do
      it "redirects to sign in page" do
        user = Fabricate(:user, token: SecureRandom.urlsafe_base64)
        post :update, token: user.token, password: "new_password"
        expect(response).to redirect_to sign_in_path
      end

      it "updates the user's password with valid token" do
        user = Fabricate(:user, token: SecureRandom.urlsafe_base64)
        post :update, token: user.token, password: "new_password"
        expect(user.reload.authenticate("new_password")).to be_true
      end

      it "resets token to nil after updating password" do
        user = Fabricate(:user, token: SecureRandom.urlsafe_base64)
        post :update, token: user.token, password: "new_password"
        expect(user.reload.token).to be_nil
      end

      it "sets a success message" do
        user = Fabricate(:user, token: SecureRandom.urlsafe_base64)
        post :update, token: user.token, password: "new_password"
        expect(flash[:notice]).not_to be_blank
      end
    end

    context "with invalid token" do
      it "redirect to token invalid token page" do
        user = Fabricate(:user, token: SecureRandom.urlsafe_base64)
        post :update, token: SecureRandom.urlsafe_base64, password: "new_password"
        expect(response).to redirect_to invalid_token_path
      end

      it "does not update the user's password with invalid token" do
        user = Fabricate(:user, token: SecureRandom.urlsafe_base64)
        post :update, token: SecureRandom.urlsafe_base64, password: "new_password"
        expect(user.reload.authenticate("new_password")).to be_false
      end
    end
  end
end
