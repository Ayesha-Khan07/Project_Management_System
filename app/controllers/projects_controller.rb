class ProjectsController < ApplicationController
  before_action :authenticate_user!

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

  private

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
