module OauthAuthorize
  extend ActiveSupport::Concern

  def oauth_authorize(provider)
    @user = User.find_for_oauth(auth)
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      if params['controller'] == 'oauth_email_confirmations'
        params[:notice] = 'Signed up!'
      else
        set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
      end
    elsif @user
      redirect_to new_oauth_email_confirmation_path
      session[:provider] = auth.provider
      session[:uid] = auth.uid
    else
      redirect_to root_path 'Something went wrong'
    end
  end

  private

  def auth
    request.env['omniauth.auth']
  end
end
