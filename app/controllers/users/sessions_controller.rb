require 'jwt'

class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def current_token
    # Generate JWT token manually
    payload = { 
      sub: resource.id, 
      user_id: resource.id,
      exp: 1.day.from_now.to_i 
    }
    JWT.encode(payload, Rails.application.secret_key_base)
  end

  def respond_with(resource, _opts = {})
    render json: {
      message: 'Logged in successfully',
      user: resource,
      token: current_token
    }, status: :ok
  end

  def respond_to_on_destroy(_resource_name)
    render json: {
      message: 'Logged out successfully'
    }, status: :ok
  end
end