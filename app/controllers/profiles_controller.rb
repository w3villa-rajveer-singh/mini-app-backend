class ProfilesController < ApplicationController
  include Rails.application.routes.url_helpers
  before_action :authenticate_user!

  def show
    render json: {
      message: "Authorized",
      user: current_user,
      avatar_url: current_user.avatar.attached? ? url_for(current_user.avatar) : nil,
      location: {
        address: current_user.address,
        latitude: current_user.latitude,
        longitude: current_user.longitude
      }
    }
  end

  def update
    if current_user.update(profile_params)
      render json: {
        message: "Profile updated successfully",
        user: current_user,
        avatar_url: current_user.avatar.attached? ? url_for(current_user.avatar) : nil,
        location: {
          address: current_user.address,
          latitude: current_user.latitude,
          longitude: current_user.longitude
        }
      }
    else
      render json: {
        errors: current_user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:user).permit(:name, :avatar, :address, :latitude, :longitude)
  end
end