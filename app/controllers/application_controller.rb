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

    user_id = decoded['sub'] || decoded['user_id'] || decoded['id']

    @current_user = User.find(user_id)
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
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