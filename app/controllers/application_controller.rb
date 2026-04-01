class ApplicationController < ActionController::API
  include Devise::Controllers::Helpers

  respond_to :json

  private

  def store_location_for(resource, location)
    # do nothing (disable session storage)
  end

  def authenticate_user!
    render json: { error: 'Not Authorized' }, status: :unauthorized unless current_user
  end
end