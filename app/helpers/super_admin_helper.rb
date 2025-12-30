module SuperAdminHelper
    def system_user
      @system_user ||= User.find_by!(email: "system@gmail.com")
    end

    def system_user?(user = current_user)
    user.present? && user.email == "system@gmail.com"
  end

  def super_admin_user?(user = current_user)
    user.present? && user.email == "superadmin@gmail.com"
  end
end
