class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :store_current_location, :unless => :devise_controller?

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
end
