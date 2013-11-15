require "spec_helper"

describe InvitationsController do
  describe "GET #new" do
    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end

    it "sets @invitation" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_instance_of(Invitation)
      expect(assigns(:invitation)).to be_new_record
    end
  end

  describe "POST #create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create, invitation: {recipient_name: "bob", recipient_email: "bob@example.com", message: "Join my site!"} }
    end

    before { set_current_user }

    context "with valid input information" do
      it "redirects to invite page" do
        post :create, invitation: Fabricate.attributes_for(:invitation)
        expect(response).to redirect_to invite_path
      end

      it "create a invitation" do
        post :create, invitation: Fabricate.attributes_for(:invitation)
        expect(Invitation.count).to eq(1)
      end

      it "create a invitation associated with current user" do
        post :create, invitation: Fabricate.attributes_for(:invitation)
        expect(Invitation.first.inviter).to eq(current_user)
      end

      it "sends out an invitation email to recipient" do
        post :create, invitation: Fabricate.attributes_for(:invitation, recipient_email: "bob@example.com")
        expect(ActionMailer::Base.deliveries.last.to).to eq(["bob@example.com"])
      end

      it "sends out the mail containing user's invitation message" do
        post :create, invitation: Fabricate.attributes_for(:invitation, message: "Join my site!")
        expect(ActionMailer::Base.deliveries.last.body).to include("Join my site!")
      end

      it "sets a success message" do
        post :create, invitation: Fabricate.attributes_for(:invitation, message: "Join my site!")
        expect(flash[:notice]).to be_present
      end
    end

    context "with invalid input information" do
      it "render the :new template" do
        post :create, invitation: Fabricate.attributes_for(:invitation, recipient_email: nil)
        expect(response).to render_template :new
      end

      it "does not create an invitation" do
        post :create, invitation: Fabricate.attributes_for(:invitation, recipient_email: nil)
        expect(Invitation.count).to eq(0)
      end

      it "does not send out a invitation email" do
        ActionMailer::Base.deliveries.clear
        post :create, invitation: Fabricate.attributes_for(:invitation, recipient_email: nil)
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "sets a error message" do
        post :create, invitation: Fabricate.attributes_for(:invitation, recipient_email: nil)
        expect(flash[:error]).to be_present
      end

      it "sets @invitation" do
        post :create, invitation: Fabricate.attributes_for(:invitation, recipient_email: nil)
        expect(assigns(:invitation)).to be_present
      end
    end
  end
end
