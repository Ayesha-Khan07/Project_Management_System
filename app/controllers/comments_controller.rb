class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task
  before_action :set_comment, only: [:edit, :update, :destroy]

  def create
    @comment = @task.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      #send email seperatly to each associated user ---> becoz bcc won't works 
       @task.project.users.where.not(id: current_user.id).find_each do |recipient|
        CommentMailer.with(comment: @comment, action: "created", recipient: recipient).comment_notification.deliver_now
      end
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
      
      @task.project.users.where.not(id: current_user.id).find_each do |recipient|
        CommentMailer.with(comment: @comment, action: "updated", recipient: recipient).comment_notification.deliver_now
      end

      redirect_to project_task_path(@task.project, @task), notice: "Comment updated."
    else
      redirect_to project_task_path(@task.project, @task), alert: "Not allowed or blank content."
    end
  end

  def destroy
    if @comment.user == current_user
      @comment.update(body: "This comment was deleted.")
      #send mail before redirect
      @task.project.users.where.not(id: current_user.id).find_each do |recipient|
        CommentMailer.with(comment: @comment, action: "deleted", recipient: recipient).comment_notification.deliver_now
      end

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
