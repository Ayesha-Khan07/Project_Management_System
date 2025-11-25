class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:show, :update]

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
  end

  def update
  if @project.update(project_params)
    respond_to do |format|
      format.html { redirect_to @project, notice: "Project updated successfully." }
      format.json { render json: { project: @project } }
    end
  else
    respond_to do |format|
      format.html { render :show, status: :unprocessable_entity }
      format.json { render json: { errors: @project.errors.full_messages }, status: :unprocessable_entity }
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
      :description,       # Action Text
      :uploaded_document  # ActiveStorage
    )
  end
end
