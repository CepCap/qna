class OauthEmailConfirmationsController < ApplicationController
  def new
  end

  def create
    oauth_authorize(oauth_params['provider'])
  end

  private

  def oauth_params
    params.permit(:email, :provider, :uid)
  end

  def auth_params
    OmniAuth::AuthHash.new(provider: oauth_params['provider'], uid: oauth_params['uid'], info: { email: oauth_params['email'] })
  end

  def oauth_authorize(provider)
    @user = User.find_for_oauth(auth_params)
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      flash[:notice] = 'Your account has been linked to social media!' if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
