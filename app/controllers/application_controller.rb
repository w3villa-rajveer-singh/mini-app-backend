class ApplicationController < ActionController::API
  include Devise::Controllers::Helpers

  respond_to :json

  private

  # 🔥 Decode JWT and set current_user
def current_user
  return @current_user if defined?(@current_user)

  header = request.headers['Authorization']
  return nil unless header

  token = header.split(' ').last

  begin
    decoded = JWT.decode(token, Rails.application.secret_key_base)[0]

    Rails.logger.info "🔥 DECODED JWT: #{decoded}"

    user_id = decoded['sub'] || decoded['user_id'] || decoded['id']

    Rails.logger.info "🔥 USER_ID FROM TOKEN: #{user_id}"

    @current_user = User.find(user_id)
  rescue => e
    Rails.logger.error "❌ JWT ERROR: #{e.message}"
    @current_user = nil
  end
end

  # 🔥 Use this for auth
  def authenticate_user!
    render json: { error: 'Not Authorized' }, status: :unauthorized unless current_user
  end

  def store_location_for(resource, location)
    # disable session storage
  end
end