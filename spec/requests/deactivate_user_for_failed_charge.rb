require "spec_helper"

describe "deactivate user for failed charge", vcr: true do
  let(:event_data) do
    {
      "id" => "evt_103G9b2zh8gd9Tolo4OwO4Ls",
      "created" => 1389014392,
      "livemode" => false,
      "type" => "charge.failed",
      "data" => {
        "object" => {
          "id" => "ch_103G9b2zh8gd9Toli1ekadZq",
          "object" => "charge",
          "created" => 1389014392,
          "livemode" => false,
          "paid" => false,
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "card" => {
            "id" => "card_103G9a2zh8gd9TolvPEo7J5D",
            "object" => "card",
            "last4" => "0341",
            "type" => "Visa",
            "exp_month" => 5,
            "exp_year" => 2017,
            "fingerprint" => "dvURoCEegMSBmK2e",
            "customer" => "cus_3DeUKilyDdqaY7",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil
          },
          "captured" => false,
          "refunds" => [],
          "balance_transaction" => nil,
          "failure_message" => "Your card was declined.",
          "failure_code" => "card_declined",
          "amount_refunded" => 0,
          "customer" => "cus_3DeUKilyDdqaY7",
          "invoice" => nil,
          "description" => "charge failed",
          "dispute" => nil,
          "metadata" => {}
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_3G9bTiStt2O8IP"
    }

  end

  it "deactivate user when webhook from stripe charged failed" do
    alice = Fabricate(:user, customer_token: "cus_3DeUKilyDdqaY7")
    post "/stripe_events", event_data
    expect(alice.reload).not_to be_active
  end
end
