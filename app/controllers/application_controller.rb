class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_user, :logged_in?

  private

  def current_user
    @current_user ||= User.active.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def authenticate_user!
    return if logged_in?

    redirect_to login_path, alert: "Faca login para continuar."
  end

  def authorize_admin!
    return if current_user&.admin?

    redirect_to dashboard_path, alert: "Acesso restrito a administradores."
  end
end
