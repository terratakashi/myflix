require "spec_helper"

describe StripeWrapper do
  describe StripeWrapper::Charge, :vcr do
    let(:charge) do
      token = Stripe::Token.create(
                :card => {
                  :number => card_number,
                  :exp_month => 11,
                  :exp_year => 2016,
                  :cvc => "123"} ).id
      StripeWrapper::Charge.create(
        :token => token,
        :email => "test_mode@example.com")
    end

    context "with valid card" do
      let(:card_number) {"4242424242424242"}

      it "charges the card successfully" do
        expect(charge).to be_successful
        expect(charge.response.amount).to eq(999)
        expect(charge.response.currency).to eq("usd")
      end
    end

    context "with invalid card" do
      let(:card_number) {"4000000000000002"}

      it "doesn't charge the card successfully" do
        expect(charge).not_to be_successful
      end

      it "set a error message" do
        expect(charge.error_message).to be_present
      end
    end
  end

  describe StripeWrapper::Customer, :vcr do
    let(:customer) do
      token = Stripe::Token.create(
                :card => {
                  :number => card_number,
                  :exp_month => 11,
                  :exp_year => 2016,
                  :cvc => "123"} ).id
      StripeWrapper::Customer.create(
        :email => "test_mode@example.com",
        :plan => "month_member",
        :card => token)
    end

    context "with valid card" do
      let(:card_number) {"4242424242424242"}

      it "charges the customer successfully" do
        expect(customer).to be_successful
        expect(customer.response.subscription.plan.amount).to eq(999)
        expect(customer.response.subscription.plan.currency).to eq("usd")
      end
    end

    context "with invalid card" do
      let(:card_number) {"4000000000000002"}

      it "doesn't charge the card successfully" do
        expect(customer).not_to be_successful
      end

      it "set a error message" do
        expect(customer.error_message).to be_present
      end
    end
  end
end
