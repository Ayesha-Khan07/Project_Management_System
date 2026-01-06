class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :ensure_company_exists
  before_action :configure_sign_up_params, only: [:create]

  # GET /users/sign_up
  def new
    build_resource
    yield resource if block_given?
    respond_with resource
  end

  # POST /users
  def create
    build_resource(sign_up_params)
    resource.role = "admin" # Default role for new signups
    
    if resource.save
      yield resource if block_given?
      if resource.active_for_authentication?
        # Send welcome email
        UserMailer.welcome_email(resource).deliver_later
        
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  protected

  def after_sign_up_path_for(resource)
    if resource.role == "admin"
      new_company_path
    else
      root_path
    end
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :password, :password_confirmation, :role])
  end

  # def sign_up_params
  #   params.require(:user).permit(:username, :email, :password, :password_confirmation, :role)
  # end
end