class CommentMailer < ApplicationMailer
   def comment_notification
    @comment = params[:comment]
    @task = @comment.task
    @project = @task.project
    @user = @comment.user
    @action = params[:action]
    @recipient = params[:recipient]

    mail(
      to: @recipient.email,
      subject: "Comment on #{@task.title} (#{@action})"
    )
  end
end
