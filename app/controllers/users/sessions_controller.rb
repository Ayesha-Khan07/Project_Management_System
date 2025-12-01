class Users::SessionsController < Devise::SessionsController
  skip_before_action :ensure_company_exists

  # GET /users/sign_in
  def new
    super
  end

  # POST /users/sign_in
  def create
    super
  end

  # DELETE /users/sign_out
  def destroy
    super
  end

  protected

  def after_sign_in_path_for(resource)
    if resource.super_admin?
      super_admin_dashboard_path
    elsif resource.client? || resource.employee?
      if resource.project_id?
        project_path(resource.project)
      else
        root_path
      end
    elsif resource.company_id?
      company_path(resource.company)
    else
      new_company_path
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end