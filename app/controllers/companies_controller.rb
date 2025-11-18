class CompaniesController < ApplicationController
  
  before_action :authenticate_user!
  before_action :set_company, only: [:show, :update]
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
     current_user.update(company: @company)
     redirect_to company_path(@company), notice: "Company created successfully."
   else
     flash.now[:alert] = "Failed to create company."
     render :new, status: :unprocessable_entity
   end
  end

  def show
    @company = current_user.company
    redirect_to root_path, alert: "No company found" if @company.nil?
  end

  def update
    if @company.update(logo: params[:company][:logo])
      redirect_to company_path(@company), notice: "Logo updated successfully."
    else
      redirect_to company_path(@company), alert: "Failed to update logo."
    end
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
