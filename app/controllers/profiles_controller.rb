class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    render json: {
      message: "Authorized",
      user: current_user
    }
  end
end