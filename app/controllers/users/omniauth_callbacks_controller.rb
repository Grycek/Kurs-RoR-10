class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    omniauth = env["omniauth.auth"]
    @user = User.find_for_facebook_oauth(omniauth, current_user)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      #@user.authentications.find_or_create_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
      sign_in_and_redirect @user, :event => :authentication
    else
      flash[:error]  = I18n.t "devise.omniauth_callbacks.failure", :kind => "Facebook", :reason => "reason"
      flash[:error] += "Try again."
      redirect_to root_path
      #session["devise.facebook_data"] = env["omniauth.auth"]
      #redirect_to new_user_registration_url
    end
  end
end
