class ApplicationController < ActionController::API
  include ActionController::Cookies
  include Devise::Controllers::Helpers

  respond_to :json

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: [:avatar, :address, :latitude, :longitude]
    )

    devise_parameter_sanitizer.permit(
      :account_update,
      keys: [:avatar, :address, :latitude, :longitude]
    )
  end
end