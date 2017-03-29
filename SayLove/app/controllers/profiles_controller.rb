class ProfilesController < ApplicationController
  
  before_filter :require_login

  def index
  end

  def notifications
    @page_id = 'notifications'

    current_user = User.find(session[:user_id])

    @notifications = current_user.notifications.order('created_at DESC').paginate(:page => params[:page])
  end
end
