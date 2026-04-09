class Admin::UsersController < ApplicationController
  before_action :authenticate_user!   # Devise login check
  before_action :authorize_admin!     # Admin check

  def index
    @q = User.ransack(params[:q])

    users = @q.result(order: 'created_at desc')
    users = users.page(params[:page]).per(10)

    render json: {
      users: users,
      current_page: users.current_page,
      total_pages: users.total_pages,
      total_count: users.total_count
    }
  end

  private

  def authorize_admin!
    render json: { error: "Not authorized" }, status: :forbidden unless current_user&.admin?
  end
end