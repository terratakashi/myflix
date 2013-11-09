require "spec_helper"

describe UsersController do

  describe "GET #new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST #create" do
    context "with valid input" do
      before { post :create, user: {email: "example@example.com", full_name: "Alex Chen", password: "password"} }

      it "create the user" do
        expect(User.count).to eq(1)
      end

      it "redirects to sign in page" do
        expect(response).to redirect_to sign_in_path
      end
    end

    context "with invalid input" do
      before { post :create, user: {full_name: "Alex Chen", password: "password"} }

      it "doesn't create the user" do
        expect(User.count).to eq(0)
      end

      it "sets the @user variable" do
        expect(assigns(:user)).to be_instance_of(User)
      end

      it "renders :new template" do
        expect(response).to render_template :new
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
