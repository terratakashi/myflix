require "spec_helper"

describe StripeWrapper do
  describe StripeWrapper::Charge, :vcr do
    before { StripeWrapper.set_api_key }

    context "with valid card" do
      it "charges the card successfully" do
        card_number = "4242424242424242"
        token = Stripe::Token.create(
                  :card => {
                    :number => card_number,
                    :exp_month => 11,
                    :exp_year => 2016,
                    :cvc => "123"} ).id
        charge = StripeWrapper::Charge.create(
          :token => token,
          :email => "test_mode@example.com")
        expect(charge).to be_successful
        expect(charge.response.amount).to eq(999)
        expect(charge.response.currency).to eq("usd")
      end
    end

    context "with invalid card" do
      it "doesn't charge the card successfully" do
        card_number = "4000000000000002"

        token = Stripe::Token.create(
                  :card => {
                    :number => card_number,
                    :exp_month => 11,
                    :exp_year => 2016,
                    :cvc => "123"} ).id

        charge = StripeWrapper::Charge.create(
          :token => token,
          :email => "test_mode@example.com")

        expect(charge).not_to be_successful
      end

      it "set a error message" do
        card_number = "4000000000000002"
        token = Stripe::Token.create(
                  :card => {
                    :number => card_number,
                    :exp_month => 11,
                    :exp_year => 2016,
                    :cvc => "123"} ).id
        charge = StripeWrapper::Charge.create(
          :token => token,
          :email => "test_mode@example.com")

        expect(charge.error_message).to be_present
      end
    end
  end
end
