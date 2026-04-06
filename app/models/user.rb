class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
       :recoverable, :rememberable, :validatable,
       :confirmable,
       :jwt_authenticatable,
       :omniauthable,
       jwt_revocation_strategy: JwtDenylist,
       omniauth_providers: [:google_oauth2, :facebook]

  def self.from_omniauth(auth)
    email = auth.info.email

    # 🔥 SAFETY: handle nil email
    unless email.present?
      email = "temp_#{SecureRandom.hex(5)}@example.com"
    end

    user = User.find_by(email: email)

    if user
      user.update(
        provider: auth.provider,
        uid: auth.uid,
        name: auth.info.name
      )
    else
      user = User.create!(
      email: email,
      password: Devise.friendly_token[0, 20],
      provider: auth.provider,
      uid: auth.uid,
      name: auth.info.name,
      confirmed_at: Time.current
      )
    end

    user
  end
end