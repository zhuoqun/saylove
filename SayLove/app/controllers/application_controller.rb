class ApplicationController < ActionController::Base
  protect_from_forgery

  def require_login
    if session[:user_id].nil?
      flash[:notice] = t :must_login

      respond_to do |format|
        format.html {
          session[:return_to] = request.fullpath
          redirect_to login_path
        }

        format.json { render json: {:status => -2} }
      end
    end
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def add_notification(user_id, letter_id, category)
    return if session[:user_id].nil? || user_id == session[:user_id]

    notification = Notification.where(:user_id => user_id, :letter_id => letter_id, :category => category, :unread => true).first_or_create
    notification.count += 1

    notification.save
  end

end
