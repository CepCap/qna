class OauthEmailConfirmationsController < ApplicationController
  include OauthAuthorize

  def new
  end

  def create
    oauth_authorize(session[:provider])
  end

  private

  def email_params
    params.permit(:email)
  end

  def auth
    OmniAuth::AuthHash.new(provider: session[:provider], uid: session[:uid], info: email_params, confirm: true)
  end
end
