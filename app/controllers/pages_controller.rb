class PagesController < ApplicationController
  def home
     @company = current_user.company if user_signed_in?
  end
end
