class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    handle_auth
  end

  def facebook
    handle_auth
  end

  def failure
    Rails.logger.error "OAuth Failure: #{request.env['omniauth.error']}"
    redirect_to "#{frontend_url}/login"
  end

  private

  def handle_auth
    auth = request.env['omniauth.auth']

    # 🔥 Debug log (very useful)
    Rails.logger.info "OMNIAUTH AUTH DATA: #{auth.inspect}"

    # ❌ Safety check
    unless auth
      Rails.logger.error "Auth data is nil"
      return redirect_to "#{frontend_url}/login"
    end

    @user = User.from_omniauth(auth)

    if @user&.persisted?
      sign_in(@user)

      # ✅ Get JWT
      token = request.env['warden-jwt_auth.token']
      token ||= Warden::JWTAuth::UserEncoder.new.call(@user, :user, nil).first

      Rails.logger.info "JWT TOKEN: #{token}"

      redirect_to "#{frontend_url}/social-login?token=#{token}"
    else
      Rails.logger.error "User not persisted"
      redirect_to "#{frontend_url}/login"
    end
  end

  def frontend_url
    Rails.env.production? ? ENV['FRONTEND_URL'] : "http://localhost:3002"
  end
end