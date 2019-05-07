class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    if oauth && oauth.info[:email].nil? && find_authorization.nil?
      redirect_to new_oauth_email_confirmation_path(provider: oauth.provider, uid: oauth.uid)
    else
      oauth_authorize('github')
    end
  end

  def vkontakte
    if oauth && oauth.info[:email].nil? && find_authorization.nil?
      redirect_to new_oauth_email_confirmation_path(provider: oauth.provider, uid: oauth.uid)
    else
      oauth_authorize('vkontakte')
    end
  end

  private

  def oauth_authorize(provider)
    @user = User.find_for_oauth(oauth)
    if @user&.persisted?
      @user.skip_confirmation!
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def find_authorization
    Authorization.find_by(provider: oauth.provider, uid: oauth.uid.to_s)
  end

  def oauth
    request.env['omniauth.auth']
  end
end
