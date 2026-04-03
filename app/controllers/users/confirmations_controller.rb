class Users::ConfirmationsController < Devise::ConfirmationsController
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    frontend_url = ENV["FRONTEND_URL"]

    if resource.errors.empty?
      redirect_to "#{frontend_url}/login?confirmed=true", allow_other_host: true
    else
      redirect_to "#{frontend_url}/auth-error?message=invalid_or_expired", allow_other_host: true
    end
  end
end