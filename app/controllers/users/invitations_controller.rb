class Users::InvitationsController < ApplicationController
  skip_before_action :ensure_company_exists

  # GET /accept_invite?token=xxx
  def accept_invite
    @invitation = Invitation.find_by(token: params[:token])

    if @invitation.nil? || @invitation.used || @invitation.expired?
      redirect_to root_path, alert: "Invalid or expired invitation"
      return
    end

    # Check if user already exists
    existing_user = User.find_by(email: @invitation.email)
    if existing_user
      redirect_to new_user_session_path, notice: "Account already exists. Please login."
      return
    end

    @user = User.new(email: @invitation.email, role: @invitation.role)

    #to resolve the no template found issue - as the devise controller and view folder name is diff
    render "devise/invitations/accept_invite"
  end

  # POST /register_from_invite
  def register_from_invite
    @invitation = Invitation.find_by(token: params[:user][:token])
    
    if @invitation.nil? || @invitation.used || @invitation.expired?
      redirect_to root_path, alert: "Invalid or expired invitation"
      return
    end

    existing_user = User.find_by(email: @invitation.email)
    if existing_user
      redirect_to new_user_session_path, notice: "Account already exists. Please login."
      return
    end

    @user = User.new(user_params)
    @user.company = @invitation.project.company
    @user.project = @invitation.project

    if @user.save
      @invitation.update(used: true)
      
      # Send welcome email
      UserMailer.welcome_email(@user).deliver_later
      
      sign_in(@user)
      redirect_to project_path(@invitation.project), notice: "Account created successfully!"
    else
      render :accept_invite, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation, :role)
  end
end