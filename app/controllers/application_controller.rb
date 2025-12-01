class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :ensure_company_exists


  private
  
  def ensure_company_exists
    return unless user_signed_in?     #return from this method if user is not signed-in
    return if current_user.super_admin?

    if current_user.company_id.nil?   # user don't have any company
      redirect_to new_company_path unless on_company_pages?
    end
  end

  def on_company_pages?
    controller_name == "companies"
  end

end
