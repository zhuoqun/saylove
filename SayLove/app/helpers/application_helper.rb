module ApplicationHelper
  def global_nav_items_logged_in
    unread_echos_count = Letter.unread_echo_letters_by_user(current_user)
    unread_echos_count = nil if unread_echos_count == 0

    unread_notificatioins_count = current_user.notifications.where(:unread => true).count
    unread_notificatioins_count = nil if unread_notificatioins_count == 0

    [{:id => 'index', :url => root_url}, {:id => 'echobox', :url => echobox_path, :unread_count => unread_echos_count}, {:id => 'sentbox', :url => sentbox_path}, {:id => 'favorites', :url => favorites_path}, {:id => 'notifications', :url => notifications_path, :unread_count => unread_notificatioins_count}, {:id => 'settings', :url => settings_path}, {:id => 'logout', :url => logout_path}]
  end

  def global_nav_items_unlog_in
    [{:id => 'random', :url => recent_path}, {:id => 'login', :url => login_path}]
  end

  def current_user
    @current_user = session[:user_id].present? ? User.find(session[:user_id]) : nil
  end

  def get_provider_display_name
    t(current_user.provider.provider.to_sym)
  end

  def has_sent_flower?(letter_id)
    return false if !current_user

    Flower.find_by_user_id_and_letter_id(session[:user_id], letter_id).present?
  end

  def has_favorited?(letter_id)
    return false if !current_user

    Favorite.find_by_user_id_and_letter_id(session[:user_id], letter_id).present?
  end

  def truncate_letter_content(content)
    content = sanitize(content)
    content = content.gsub(/<\/p>/, '')
    content = content.gsub(/<p>/, '')

    truncate(content, :length => 120, :omission => '...')
  end

end
