module ProjectsHelper

    #helper method for user roles who can edit the project
    def can_edit_project?(user)
    user.role.in?(%w[admin manager super_admin])
    end
end
