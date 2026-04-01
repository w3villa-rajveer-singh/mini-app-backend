class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def current_token
    request.env['warden-jwt_auth.token']
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