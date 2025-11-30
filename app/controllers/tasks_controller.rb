class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:new, :create]
  before_action :set_task, only: [:show]

  def new
    @task = @project.tasks.build
    # Only employees of the project’s company
    @employees = @project.company.users.where(role: "employee")
  end

  def create
    @task = @project.tasks.build(task_params)
    if @task.save
      redirect_to project_task_path(@project, @task), notice: "Task created successfully."
    else
      @employees = @project.company.users.where(role: "employee")
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(
      :title,
      :description,
      :task_type,
      :status,
      :progress,
      :estimated_deadline,
      :assigned_user_id
    )
  end
end
