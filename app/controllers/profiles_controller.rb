class ProfilesController < ApplicationController
  include Rails.application.routes.url_helpers
  before_action :authenticate_user!

  def show
    render json: {
      message: "Authorized",
      user: {
        id: current_user.id,
        email: current_user.email,
        name: current_user.name,
        admin: current_user.admin,
        plan_type: current_user.plan_type,
        plan_expiry: current_user.plan_expiry,
        provider: current_user.provider,
        uid: current_user.uid,
        created_at: current_user.created_at,
        updated_at: current_user.updated_at
      },
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