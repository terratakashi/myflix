require "spec_helper"

describe UsersController do

  describe "GET #new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "GET #new_with_invitation_token" do
    it "render :new template with valid token" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template(:new)
    end

    it "sets @user with recipient's mail" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end

    it "sets @invitation_token" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end

    it_behaves_like "requires a valid token" do
      let(:action) { get :new_with_invitation_token, token: "invalid_token" }
    end
  end

  describe "POST #create" do
    context "successful user sign up" do
      before do
        user_registration = double("user registration", successful?: true)
        UserRegistration.any_instance.should_receive(:sign_up).and_return(user_registration)

        post :create, user: Fabricate.attributes_for(:user)
      end

      it "sets a successful notice" do
        expect(flash[:notice]).to be_present
      end

      it "redirects to sign in page" do
        expect(response).to redirect_to sign_in_path
      end
    end

    context "failed user sign up" do
      before do
        user_registration = double("user registration", successful?: false, error_message: "error_message")
        UserRegistration.any_instance.should_receive(:sign_up).and_return(user_registration)

        post :create, user: Fabricate.attributes_for(:user)
      end

      it "sets the @user variable" do
        expect(assigns(:user)).to be_instance_of(User)
      end

      it "render new template" do
        expect(response).to render_template :new
      end

      it "sets a error message" do
        expect(flash[:error]).to eq("error_message")
      end
    end
  end

  describe "GET #show" do
    before {set_current_user}

    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: 1 }
    end

    it "sets @user variable" do
      user = Fabricate(:user)

      get :show, id: user
      expect(assigns(:user)).to eq(user)
    end

    it "sets @queue_items variable" do
      user = Fabricate(:user)
      Fabricate(:queue_item, user: user)
      Fabricate(:queue_item, user: user)

      get :show, id: user
      expect(assigns(:queue_items)).to eq(user.queue_items)
    end

    it "sets @review variable" do
      user = Fabricate(:user)
      Fabricate(:review, user: user)
      Fabricate(:review, user: user)

      get :show, id: user
      expect(assigns(:reviews)).to eq(user.reviews)
    end
  end
end
