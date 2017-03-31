class Member < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:slack]


  def self.from_omniauth(auth)
    puts auth.provider
    puts auth.uid
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      puts auth
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      #user.username = auth.info.nickname
    end
  end

  def self.new_with_session(params, session)
    if session["devise.member_attributes"]
      new(session["devise.member_attributes"], without_protection: true) do |member|
        member.attributes = params
        member.valid?
      end
    else
      super
    end
  end

  def password_required?
    super && provider.blank?
  end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end

  def email_required?
    false
  end

end
