class TaskMailer < ApplicationMailer

    def overdue_task(user, task)
        @user = user
        @task = task

        mail(
            to: @user.email,
            subject: "Overdue Task Alert of Task - #{@task.title}"
        )
    end

end
