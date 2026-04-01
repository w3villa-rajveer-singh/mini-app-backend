class Users::ConfirmationsController < Devise::ConfirmationsController
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      # Just redirect to login (NO auto login)
      redirect_to "http://localhost:3002/login?confirmed=true"
    else
      redirect_to "http://localhost:3002/auth-error?message=invalid_or_expired"
    end
  end
end