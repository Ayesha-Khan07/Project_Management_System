module ApplicationHelper
  def system_user
      @system_user ||= User.find_by!(email: "system@gmail.com")
    end
    
  def nav_link
    "text-gray-700 font-medium hover:text-teal-600"
  end
end
