class OverdueTasksReminderJob < ApplicationJob
  queue_as :default

  def perform
    Task.overdue.includes(:assigned_user, project: :users).find_each do |task|
      # Notify assigned users 
      TaskMailer.overdue_task(task.assigned_user, task).deliver_now

      # Notify managers 
      managers = task.project.users.where(role: "manager")

      managers.each do |manager|
        TaskMailer.overdue_task(manager, task).deliver_now
      end

    end 

  end

end