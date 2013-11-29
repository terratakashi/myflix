module StripeWrapper
  class Charge
    attr_reader :response

    def initialize(response, status)
      @response = response
      @status = status
    end

    def self.create( options = {} )
      StripeWrapper.set_api_key
      begin
        response = Stripe::Charge.create(
          :amount => 999,
          :currency => "usd",
          :card => options[:token],
          :description => "Sign up charge for: #{options[:email]}")
        Charge.new(response, :success)
      rescue Stripe::CardError => e
        Charge.new(e, :error)
      end
    end

    def successful?
      @status == :success
    end

    def error_message
      @response.message
    end
  end

  def self.set_api_key
    Stripe.api_key = ENV['STRIPE_API_KEY']
  end
end
