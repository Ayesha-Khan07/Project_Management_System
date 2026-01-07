class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:new, :create, :index, :edit, :update]
  before_action :set_task, only: [:show, :edit, :update]
  before_action :set_paper_trail_whodunnit

  def new
    @task = @project.tasks.build
    # Only employees of the project’s company
    @employees = @project.users.where(role: ["employee", "manager"])

  end

  def create
    @task = @project.tasks.build(task_params)
    if @task.save
      redirect_to project_task_path(@project, @task)
    else
      @employees = @project.company.users.where(role: "employee")
      render :new, status: :unprocessable_entity
    end
  end

  def index
    tasks = @project.tasks.includes(:assigned_user).order(created_at: :desc)
    ordered_statuses = %w[to_do in_progress to_verify done]

    grouped = tasks.group_by(&:task_status)

    @tasks_by_status = ordered_statuses.each_with_object({}) do |status_key, h|
      h[status_key] = grouped[status_key] || []
    end  
  end 

  def edit
  @task = @project.tasks.find(params[:id])
  # Only employees of the project's company
  @employees = @project.company.users.where(role: "employee")
  end

  def update
   @task = @project.tasks.find(params[:id])
   PaperTrail.request.whodunnit = current_user.id  

   if @task.update(task_params)
     redirect_to project_task_path(@project, @task)
   else
     @employees = @project.company.users.where(role: "employee")
     render :edit, status: :unprocessable_entity
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
      :task_status,
      :progress,
      :estimated_deadline,
      :assigned_user_id
    )
  end
end
