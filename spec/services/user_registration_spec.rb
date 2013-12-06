require "spec_helper"

describe UserRegistration do

  describe "#sign_up" do
    context "with valid user info and valid credit card" do
      before do
        charge = double("charge", successful?: true)
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
      end

      it "create the user" do
        user = Fabricate.build(:user)
        UserRegistration.new(user).sign_up("trip_token", nil)
        expect(User.count).to eq(1)
      end

      it "makes the user follow the inviter" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice)
        bob = Fabricate.build(:user, email: invitation.recipient_email)
        UserRegistration.new(bob).sign_up("strip_token", invitation.token)
        expect(bob.following?(alice)).to be_true
      end

      it "makes the inviter follow the user" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice)
        bob = Fabricate.build(:user, email: invitation.recipient_email)
        UserRegistration.new(bob).sign_up("strip_token", invitation.token)
        expect(alice.following?(bob)).to be_true
      end

      it "expires the invitation upon acceptance" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice)
        bob = Fabricate.build(:user, email: invitation.recipient_email)
        UserRegistration.new(bob).sign_up("strip_token", invitation.token)
        expect(Invitation.first.token).to be_nil
      end

      context "sending email" do
        let(:mailbox) { ActionMailer::Base.deliveries }

        before do
          mailbox.clear
          user = Fabricate.build(:user, full_name: "Alex Chen", email: "example@example.com")
          UserRegistration.new(user).sign_up("strip_token", nil)
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
    end

    context "with valid user infor but invalid credit card" do
      before do
        charge = double(:dont_charge, successful?: false, error_message: "error_message")
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
      end

      it "does not create the user" do
        user = Fabricate.build(:user)
        UserRegistration.new(user).sign_up("strip_token", nil)
        expect(User.count).to eq(0)
      end

      it "does not send out a email" do
        ActionMailer::Base.deliveries.clear
        user = Fabricate.build(:user)
        UserRegistration.new(user).sign_up("strip_token", nil)
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "sets error_message" do
        user = Fabricate.build(:user)
        result = UserRegistration.new(user).sign_up("strip_token", nil)
        expect(result.error_message).to be_present
      end
    end

    context "with invalid user info" do
      before do
        StripeWrapper::Charge.should_not_receive(:create)
      end

      it "doesn't create the user" do
        user = Fabricate.build(:user, email: nil)
        UserRegistration.new(user).sign_up("strip_token", nil)
        expect(User.count).to eq(0)
      end

      it "does not charge the credit card" do
        user = Fabricate.build(:user, email: nil)
        UserRegistration.new(user).sign_up("strip_token", nil)
        expect(StripeWrapper::Charge).not_to receive(:create)
      end

      it "sets error_message" do
        user = Fabricate.build(:user, email: nil)
        result = UserRegistration.new(user).sign_up("strip_token", nil)
        expect(result.error_message).to be_present
      end
    end
  end
end
