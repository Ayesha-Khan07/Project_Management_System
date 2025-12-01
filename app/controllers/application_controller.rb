class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :ensure_company_exists, unless: :devise_controller?

  private
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end

  def ensure_company_exists
    return unless user_signed_in?
    return if current_user.super_admin?
    
    if current_user.company_id.nil? && !on_company_pages?
      redirect_to new_company_path
    end
  end

  def on_company_pages?
    controller_name == "companies" || 
    controller_path.start_with?("super_admin/")
  end
end