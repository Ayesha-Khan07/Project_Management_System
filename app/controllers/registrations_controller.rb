class RegistrationsController < ApplicationController
  def new_ceo
    @user = User.new
  end

  def create_ceo
    @user = User.new(ceo_params)
    @user.role = "admin"
    if @user.save
      sign_in(@user)
      redirect_to new_company_path, notice: "Great! Now complete your company profile."
    else
      render :new_ceo, status: :unprocessable_entity
    end
  end

  def login_ceo
    if request.get?       # for get request
      @user = User.new      # just create a new obj to store the email,password and return
      return
    end

    @user = User.new(ceo_params)
    user = User.find_by(email: ceo_params[:email].to_s.downcase)

    if user&.valid_password?(ceo_params[:password])
      sign_in(user)
      redirect_to company_path(current_user.company), notice: "Login successfully."
    else
      flash.now[:alert] = "Invalid email or password"
      render :login_ceo, status: :unprocessable_entity
    end
  end

  def ceo_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation)
  end
end
