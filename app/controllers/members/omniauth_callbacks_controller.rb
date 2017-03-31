class Members::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    puts request.env["omniauth.auth"]
    member = Member.from_omniauth(request.env["omniauth.auth"])

    if member.persisted?
      sign_in_and_redirect member, :event => :authentication #this will throw if @member is not activated
      set_flash_message(:notice, :success, :kind => "Slack") if is_navigational_format?
    else
      session["devise.member_attributes"] = member.attributes
      redirect_to new_member_registration_url
    end
  end

  alias_method :slack, :all

  def failure
    redirect_to root_path
  end

end
