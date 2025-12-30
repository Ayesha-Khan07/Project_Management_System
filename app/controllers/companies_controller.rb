class CompaniesController < ApplicationController

  before_action :authenticate_user!
  before_action :set_company, only: [:show, :update, :remove_user]
  before_action :authorize_company_admin!, only: [:update]

  def new
    @company = Company.new
  end

  def create
    # same user can't create multiple companies 
    if current_user.company.present?
      redirect_to company_path(current_user.company), alert: "You already have a company."
      return
    end

   @company = Company.new(company_params)

   if @company.save
     current_user.update(company: @company)         # === current_user.company = @company
                                                    # current_user.save

     redirect_to company_path(@company)
   else
     flash.now[:alert] = "Failed to create company."
     render :new, status: :unprocessable_entity
   end
  end

  def show
    redirect_to root_path, alert: "No company found" if @company.nil?
  end

  def update
    Rails.logger.info "PARAMS: #{params.inspect}"
    
    if @company.update(company_params)
      redirect_to company_path(@company), notice: "Company updated successfully."
    else
      flash.now[:alert] = "Update failed."
      render :show, status: :unprocessable_entity
    end
  end

  def remove_user
    user = @company.users.find(params[:user_id])

    Company.transaction do
      # 1️⃣ Reassign tasks
      Task.where(assigned_user_id: user.id).update_all(
        assigned_user_id: system_user.id
      )

      # 2️⃣ Reassign comments
      Comment.where(user_id: user.id).update_all(
        user_id: system_user.id
      )

      # 3️⃣ Remove from projects
      user.projects_users.delete_all

      # 4️⃣ Remove from company (NOT delete user)
      user.update!(company_id: nil)
    end

    redirect_to company_path(@company), notice: "User removed from company successfully."
  end

  private

  def company_params
    params.require(:company).permit(
      :name,
      :description,
      :services,
      :logo,
      :subscription_status,
      :member_limit
    )
  end

  def set_company()
    @company = Company.find(params[:id])
  end

  def authorize_company_admin!
    unless @company.users.exists?(id: current_user.id, role: "admin")
      redirect_to company_path(@company), alert: "Not authorized."
    end
  end


end
