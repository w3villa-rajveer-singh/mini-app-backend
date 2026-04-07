class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable,
         :jwt_authenticatable,
         :omniauthable,
         jwt_revocation_strategy: JwtDenylist,
         omniauth_providers: [:google_oauth2, :facebook]

  # 🔥 ADD THIS METHOD HERE
  def self.from_omniauth(auth)
    email = auth.info.email

    return nil unless email.present?   # prevent crash

    user = User.find_or_initialize_by(email: email)

    user.update!(
      provider: auth.provider,
      uid: auth.uid,
      name: auth.info.name,
      password: Devise.friendly_token[0, 20],
      confirmed_at: Time.current
    )

    user
  end
end