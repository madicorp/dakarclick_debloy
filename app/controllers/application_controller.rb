class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :store_current_location, :unless => :devise_controller?
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale

  private
  def store_current_location
    store_location_for(:user, request.url)
  end
  def after_sign_out_path_for(resource)
    request.referrer || root_path
  end
  def after_update_path_for(resource)
    request.referrer || root_path
  end


  def set_locale
      I18n.locale = params[:locale] || I18n.default_locale
  end


  protected

  def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:phone_number,:name, :username, :email, :password])
      devise_parameter_sanitizer.permit(:account_update , keys: [:phone_number,:name, :username, :email])
  end

end
