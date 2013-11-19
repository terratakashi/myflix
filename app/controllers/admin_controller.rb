class AdminController < ApplicationController
  before_action :require_user
  before_action :require_admin

  def require_admin
    if !current_user.admin?
      flash[:error] = "You have no right to do that!"
      redirect_to home_path
    end
  end
end
