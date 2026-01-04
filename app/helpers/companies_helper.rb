module CompaniesHelper
    def can_edit_company?(user)
        user.role.in?(%w[admin super_admin])
    end

    def admin_name(company)
        company.company_admin&.username&.titleize || "N/A"
    end

    def subscription_status(company)
        company.subscription_status.titleize.presence || "Free Plan"
    end

    def member_limit_display(company)
        company.member_limit if company.subscription_status == "free"
    end
end
