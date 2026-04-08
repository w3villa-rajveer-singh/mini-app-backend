class PaymentsController < ApplicationController
  before_action :authenticate_user!

  def create_checkout
    price_id = params[:payment][:price_id]
    plan = params[:plan]

    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      mode: 'subscription',

      line_items: [{
        price: price_id,
        quantity: 1
      }],

      success_url: "#{frontend_url}/success?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: "#{frontend_url}/cancel",

      # ✅ Keep this (optional but useful)
      customer_email: current_user.email,

      # ✅ FIXED: Add user_id + plan
      metadata: {
        user_id: current_user.id,
        plan: plan
      }
    )

    render json: { url: session.url }
  end

  private

  def frontend_url
    ENV['FRONTEND_URL']
  end
end