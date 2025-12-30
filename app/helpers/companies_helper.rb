module CompaniesHelper
    def can_edit_company?(user)
        user.role.in?(%w[admin super_admin])
    end
end
