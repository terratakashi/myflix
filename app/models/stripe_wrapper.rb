module StripeWrapper
  class Charge
    attr_reader :response

    def initialize(response, status)
      @response = response
      @status = status
    end

    def self.create( options = {} )
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

  class Customer
    attr_reader :response

    def initialize(response, status)
      @response = response
      @status = status
    end

    def self.create(options = {})
      begin
        customer = Stripe::Customer.create(
          :description => "Account: #{options[:email]}",
          :email => options[:email],
          :plan => "month_member",
          :card => options[:token])
        Customer.new(customer, :success)
      rescue Stripe::CardError => e
        Customer.new(e, :error)
      end
    end

    def successful?
      @status == :success
    end

    def error_message
      @response.message
    end

    def customer_token
      @response.id
    end
  end
end
