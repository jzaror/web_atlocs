class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :store_location
  before_action :set_locale

  private

  def store_location
    session[:requestUri] = params[:requestUri] if params[:requestUri].present?
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  rescue_from CanCan::AccessDenied do |exception|
    url=request.fullpath
    session[:url_after_session]=url
    redirect_to "/login", flash: {notice: "Para entrar a esta sección debes iniciar sesión"}
  end

  helper_method :current_user
end
