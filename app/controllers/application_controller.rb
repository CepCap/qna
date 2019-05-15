class ApplicationController < ActionController::Base
  before_action :gon_user, unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.js do
        render template: 'shared/exception_alert', locals: { message: exception.message }
      end
      format.json { render json: exception.message, status: :forbidden }
      format.html { redirect_to root_url, alert: exception.message }
    end
  end

  private

  def gon_user
    gon.user_id = current_user.id if current_user
  end
end
