require "spec_helper"

describe "create payment on successful charge", vcr: true do
  let(:event_data) do
    {
      "id" => "evt_103DdB2zh8gd9Tolt2PAWZ9D",
      "created" => 1388432526,
      "livemode" => false,
      "type" => "charge.succeeded",
      "data" => {
        "object" => {
          "id" => "ch_103DdB2zh8gd9ToljlQBf8OV",
          "object" => "charge",
          "created" => 1388432526,
          "livemode" => false,
          "paid" => true,
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "card" => {
            "id" => "card_103DdB2zh8gd9TolNB72y32w",
            "object" => "card",
            "last4" => "4242",
            "type" => "Visa",
            "exp_month" => 12,
            "exp_year" => 2016,
            "fingerprint" => "0Jf6MM8vFKQi3321",
            "customer" => "cus_3DdBUhIV8G2I9j",
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
          "captured" => true,
          "refunds" => [

          ],
          "balance_transaction" => "txn_103DdB2zh8gd9TolePyx70oc",
          "failure_message" => nil,
          "failure_code" => nil,
          "amount_refunded" => 0,
          "customer" => "cus_3DdBUhIV8G2I9j",
          "invoice" => "in_103DdB2zh8gd9ToljWj5ZeeQ",
          "description" => nil,
          "dispute" => nil,
          "metadata" => {
          }
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_3DdBwlK3ekqkF3"
    }
  end

  it "creates a payment when webhook from stripe charged succeeded" do
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end

  it "creates a payment associated with user" do
    alice = Fabricate(:user, customer_token: "cus_3DdBUhIV8G2I9j")
    post "/stripe_events", event_data
    expect(Payment.first.user).to eq(alice)
  end

  it "creates a payment with the amount" do
    post "/stripe_events", event_data
    expect(Payment.first.amount).to eq(999)
  end

  it "creates the payment with the reference_id" do
    post "/stripe_events", event_data
    expect(Payment.first.reference_id).to eq("ch_103DdB2zh8gd9ToljlQBf8OV")
  end
end
