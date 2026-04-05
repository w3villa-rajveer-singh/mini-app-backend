class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    handle_auth
  end

  def facebook
    handle_auth
  end

  private

  def handle_auth
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      sign_in(@user)  # ✅ Devise generates JWT

      token = request.env['warden-jwt_auth.token']

      redirect_to "#{frontend_url}/social-login?token=#{token}"
    else
      redirect_to "/login"
    end
  end

  def frontend_url
    Rails.env.production? ? ENV['FRONTEND_URL'] : "http://localhost:3002"
  end
end