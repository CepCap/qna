class OauthCallbacksController < Devise::OmniauthCallbacksController
  include OauthAuthorize

  def github
    oauth_authorize('github')
  end

  def vkontakte
    oauth_authorize('vkontakte')
  end
end
