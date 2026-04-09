class WebhooksController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def stripe
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = ENV['STRIPE_WEBHOOK_SECRET']

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, endpoint_secret
      )
    rescue JSON::ParserError
      return head :bad_request
    rescue Stripe::SignatureVerificationError
      return head :bad_request
    end

    # ✅ Handle event
    if event['type'] == 'checkout.session.completed'
      session = event['data']['object']

      user_id = session['metadata']['user_id']
      plan = session['metadata']['plan']

      user = User.find_by(id: user_id)

      if user
        expiry_time =
          case plan
          when "silver"
            6.hours.from_now
          when "gold"
            12.hours.from_now
          else
            1.hour.from_now
          end

        user.update(
          plan_type: plan,
          plan_expiry: expiry_time
        )
      end
    end

    head :ok
  end
end