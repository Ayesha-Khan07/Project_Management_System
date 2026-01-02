module TasksHelper
    #helper method for user roles who can edit the project
    def can_edit_task?(user)
     user.role.in?(%w[admin manager super_admin employee])
    end
end