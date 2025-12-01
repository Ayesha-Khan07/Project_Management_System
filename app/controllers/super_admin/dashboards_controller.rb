module SuperAdmin
  class DashboardsController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_super_admin!

    def index
      @active_tab = params[:tab] || 'users'
      
      case @active_tab
      when 'users'
        load_users_data
      when 'companies'
        load_companies_data
      when 'projects'
        load_projects_data
      when 'tasks'
        load_tasks_data
      end
    end

    def destroy_user
      user = User.find(params[:id])
      user.destroy
      redirect_to super_admin_dashboard_path(tab: 'users'), notice: 'User deleted successfully.'
    end

    private

    def ensure_super_admin!
      unless current_user.role == 'super_admin'
        redirect_to root_path, alert: 'Access denied. Super admin only.'
      end
    end

    def load_users_data
      @users = User.includes(:company).order(created_at: :desc)
    end

    def load_companies_data
      @companies = Company.includes(:projects).order(created_at: :desc)
      @subscription_chart_data = Company.group(:subscription_status).count
    end


    def load_projects_data
      @projects = Project.includes(:company, :client).order(created_at: :desc)
      
      # Chart data for project status
      @project_status_chart_data = Project.group(:project_status).count
    end

    def load_tasks_data
      @tasks = Task.includes(:project, :assigned_user, project: :company)
                   .order(created_at: :desc)
      
      # Chart data
      @tasks_for_charts = Task.all
      @task_type_chart_data = @tasks_for_charts.group(:task_type).count
      @task_status_chart_data = @tasks_for_charts.group(:task_status).count
      @task_progress_chart_data = @tasks_for_charts.group(:progress).count

    end
  end
end