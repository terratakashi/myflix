Stripe.api_key = ENV['STRIPE_API_KEY']

StripeEvent.setup do
  subscribe 'charge.succeeded' do |event|
    user = User.find_by_customer_token(event.data.object.customer)
    Payment.create(user: user, amount: event.data.object.amount, reference_id: event.data.object.id)
  end

  subscribe 'charge.failed' do |event|
    user = User.find_by_customer_token(event.data.object.customer)
    user.deactivate!
  end
end

