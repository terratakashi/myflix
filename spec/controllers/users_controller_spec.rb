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
    context "with valid user info and valid credit card" do
      before do
        charge = double("charge", successful?: true)
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
      end

      it "create the user" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(User.count).to eq(1)
      end

      it "redirects to sign in page" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to sign_in_path
      end

      it "makes the user follow the inviter" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice)
        post :create, user: Fabricate.attributes_for(:user, email: invitation.recipient_email), invitation_token: invitation.token
        bob = User.find_by_email(invitation.recipient_email)
        expect(bob.following?(alice)).to be_true
      end

      it "makes the inviter follow the user" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice)
        post :create, user: Fabricate.attributes_for(:user, email: invitation.recipient_email), invitation_token: invitation.token
        bob = User.find_by_email(invitation.recipient_email)
        expect(alice.following?(bob)).to be_true
      end

      it "expires the invitation upon acceptance" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice)
        post :create, user: Fabricate.attributes_for(:user, email: invitation.recipient_email), invitation_token: invitation.token
        bob = User.find_by_email(invitation.recipient_email)
        expect(Invitation.first.token).to be_nil
      end
    end

    context "with valid user infor but invalid credit card" do
      before do
        charge = double(:dont_charge, successful?: false, error_message: "error_message")
        StripeWrapper::Charge.should_receive(:create).and_return(charge)

        post :create, user: Fabricate.attributes_for(:user)
      end

      it "does not create the user" do
        expect(User.count).to eq(0)
      end

      it "render new template" do
        expect(response).to render_template :new
      end

      it "sets a error message" do
        expect(flash[:error]).to eq("error_message")
      end
    end

    context "with invalid user info" do
      before do
        StripeWrapper::Charge.should_not_receive(:create)
        post :create, user: {full_name: "Alex Chen", password: "password"}
      end

      it "doesn't create the user" do
        expect(User.count).to eq(0)
      end

      it "sets the @user variable" do
        expect(assigns(:user)).to be_instance_of(User)
      end

      it "renders :new template" do
        expect(response).to render_template :new
      end

      it "does not charge the credit card" do
        expect(StripeWrapper::Charge).not_to receive(:create)
      end
    end

    context "sending email" do
      let(:mailbox) { ActionMailer::Base.deliveries }

      context "with valid input" do
        before do
          mailbox.clear
          charge = double("charge", successful?: true)
          StripeWrapper::Charge.should_receive(:create).and_return(charge)
          post :create, user: {email: "example@example.com", full_name: "Alex Chen", password: "password"}
        end

        it "sends out a email" do
          expect(mailbox).not_to be_empty
        end

        it "sends the mail to the right recipient" do
          expect(mailbox.last.to).to eq(["example@example.com"])
        end

        it "sends out the mail containing user's name" do
          expect(mailbox.last.html_part.body).to include("Alex Chen")
          expect(mailbox.last.text_part.body).to include("Alex Chen")
        end

        it "the mail has right content" do
          expect(mailbox.last.html_part.body).to include("Welcome to myflix.com")
          expect(mailbox.last.text_part.body).to include("Welcome to myflix.com")
        end
      end

      it "does not send out a email with invalid input" do
        mailbox.clear
        StripeWrapper::Charge.should_not_receive(:create)
        post :create, user: {full_name: "Alex Chen", password: "password"}
        expect(ActionMailer::Base.deliveries).to be_empty
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
