class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
       :recoverable, :rememberable, :validatable,
       :confirmable,
       :jwt_authenticatable,
       :omniauthable,
       jwt_revocation_strategy: JwtDenylist,
       omniauth_providers: [:google_oauth2, :facebook]

  def self.from_omniauth(auth)
    user = User.find_by(email: auth.info.email)

    if user
      # 🔥 Account merge
      user.update(
        provider: auth.provider,
        uid: auth.uid
      )
    else
      user = User.create!(
        email: auth.info.email,
        password: Devise.friendly_token[0, 20],
        provider: auth.provider,
        uid: auth.uid,
        name: auth.info.name,
        confirmed_at: Time.current # 🔥 skip email confirmation
      )
    end

    user
  end
end