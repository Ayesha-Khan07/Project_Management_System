class ProjectsController < ApplicationController
    before_action :authenticate_user!

    def new 
        @project = Project.new
        @company = current_user.company
    end

    def create 
        @project = current_user.company.projects.build(project_params)      #build-> handle the associations of project & company == to new's 2 lines
        if @project.save 
            redirect_to @project, notice: "Project created sucessfully."
        else
            render :new, status: :unprocessable_entity
        end
    end

    private
    
    def project_params
        params.require(:project).permit(
            :title,
            :description,
            :status,
            :project_deadline
        )
    end

end
