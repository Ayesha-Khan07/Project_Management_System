class RegistrationsController < ApplicationController
  skip_before_action :ensure_company_exists, only: [:accept_invite, :register_from_invite] 

  def new_ceo
    @user = User.new
  end

  def create_ceo
    @user = User.new(user_params)
    @user.role = "admin"
    if @user.save
      #send welcome email when the user is signed-up
      UserMailer.welcome_email(@user).deliver_later
      
      sign_in(@user)
      if @user.role == "admin"
        redirect_to new_company_path, notice: "Great! Now complete your company profile."
      end
      redirect_to project_path(@project), notice: "You have added in project."
    else
      render :new_ceo, status: :unprocessable_entity
    end
  end

  def login_ceo
    if request.get?       # for get request
      @user = User.new      # just create a new obj to store the email,password and return
      return
    end

    @user = User.new(user_params)
    user = User.find_by(email: user_params[:email].to_s.downcase)

    if user&.valid_password?(user_params[:password])
      sign_in(user)
      if user.role == "client" || user.role == "employee"
        if user.project_id?
          redirect_to project_path(user.project), notice: "Login successfully."
        else
          redirect_to root_path, alert: "No projects found."
        end
      elsif user.role == "super_admin"
        redirect_to super_admin_dashboard_path, notice: "Login successfully."
      else
          redirect_to company_path(current_user.company), notice: "Login successfully."
      end
    else
      flash.now[:alert] = "Invalid email or password"
      render :login_ceo, status: :unprocessable_entity
    end
  end

  def accept_invite
    @invitation = Invitation.find_by(token: params[:token])

    if @invitation.nil? || @invitation.used || @invitation.expired?
      redirect_to root_path, alert: "Invalid or expired invitation"
      return
    end

    # Check if user already exists
    existing_user = User.find_by(email: @invitation.email)
    if existing_user
      redirect_to :login_ceo, notice: "Account already exists. Please login."
      return
    end

    @user = User.new(email: @invitation.email, role: @invitation.role)
  end

  def register_from_invite
    @invitation = Invitation.find_by(token: params[:user][:token])
    if @invitation.nil? || @invitation.used || @invitation.expired?
      redirect_to root_path, alert: "Invalid or expired invitation"
      return
    end

    existing_user = User.find_by(email: @invitation.email)
    Rails.logger.debug "Existing user: #{existing_user.inspect}"

    if existing_user
      redirect_to :login_ceo, notice: "Account already exists. Please login."
      return
    end

    @user = User.new(user_params)
    @user.company = @invitation.project.company
    @user.project = @invitation.project

    if @user.save
      @invitation.update(used: true)

      #send welcome mail 
      UserMailer.welcome_email(@user).deliver_later

      sign_in(@user)
      redirect_to project_path(@invitation.project), notice: "Account created successfully!"
    else
      render :accept_invite
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation, :role)
  end
end
