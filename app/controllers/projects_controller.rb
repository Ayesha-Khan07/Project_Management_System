class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:show, :update, :remove_user]
   before_action :set_paper_trail_whodunnit

  def new
    @project = Project.new
  end

  def create
    @project = current_user.company.projects.build(project_params)
    if @project.save
      redirect_to @project, notice: "Project created successfully."
    else
      Rails.logger.debug(@project.errors.full_messages)
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @project = Project.find(params[:id])  
    @company_admin = @project.company.users.find_by(role: :admin)
  end

  def update
   PaperTrail.request.whodunnit = current_user.id  
   
   if @project.update(project_params)
     respond_to do |format|
       format.html { redirect_to @project, notice: "Project updated successfully." }
       format.json do
         render json: {
           project: {
             title: @project.title,
             project_status: @project.project_status,
             project_deadline: @project.project_deadline,
             description: @project.description
           }
         }
       end
     end
   else
     Rails.logger.debug "UPDATE ERRORS: #{@project.errors.full_messages}"
     respond_to do |format|
      format.html { render :show, status: :unprocessable_entity }
      format.json { render json: { errors: @project.errors.full_messages }, status: :unprocessable_entity }
     end
   end
  end

  def index
    if params[:company_id].present?
      @company = Company.find(params[:company_id])
      if current_user.role == "admin" || current_user.role == "manager"
        @projects = @company.projects.order(created_at: :desc)
      else
        redirect_to company_path(current_user.company), alert: "You have NO ACCESS to see all the projects of the company."
        return
      end
    else
      @projects = Project.none
    end
  end

  def remove_user
    user = User.find(params[:user_id])
    if @project.users.destroy(user)
      respond_to do |format|
        format.json { render json: { success: true, user_id: user.id } }
        format.html { redirect_to @project, notice: "#{user.username} removed from project" }
      end
    else
      respond_to do |format|
        format.json { render json: { success: false }, status: :unprocessable_entity }
        format.html { redirect_to @project, alert: "Failed to remove user" }
      end
    end
  end


  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(
      :title,
      :project_status,
      :project_deadline,
      :description,       
      :uploaded_document  # ActiveStorage
    )
  end
end
