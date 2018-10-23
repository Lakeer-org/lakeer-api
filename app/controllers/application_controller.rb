class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception

  def authenticate_admin
    unless controller_name == "dashboard"
      redirect_to admin_dashboard_path unless current_user.present? && current_user.is_admin?
    end

  end


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :is_admin, :gender, :email, :password])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :email, :password, :is_admin, :gender])
  end

end
