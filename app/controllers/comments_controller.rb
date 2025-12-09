class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task
  before_action :set_comment, only: [:edit, :update, :destroy]

  def create
    @comment = @task.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to project_task_path(@task.project, @task), notice: "Comment added."
    else
      redirect_to project_task_path(@task.project, @task), alert: "Comment cannot be blank."
    end
  end

  def edit
    redirect_to project_task_path(@task.project, @task), alert: "Not allowed" unless @comment.user == current_user
  end

  def update
    PaperTrail.request.whodunnit = current_user.id

    if @comment.user == current_user && @comment.update(comment_params)
      redirect_to project_task_path(@task.project, @task), notice: "Comment updated."
    else
      redirect_to project_task_path(@task.project, @task), alert: "Not allowed or blank content."
    end
  end

  def destroy
    if @comment.user == current_user
      @comment.destroy
      redirect_to project_task_path(@task.project, @task), notice: "Comment deleted."
    else
      redirect_to project_task_path(@task.project, @task), alert: "Not allowed."
    end
  end

  private

  def set_task
    @task = Task.find(params[:task_id])
  end

  def set_comment
    @comment = @task.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
