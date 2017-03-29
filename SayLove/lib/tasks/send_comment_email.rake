namespace :mailer do
  desc "Send mails to people who recieved new comments"

  task :send_comment_email => :environment do

    @notifications = Notification.where(:unread => true, :category => 'comment', :notified => false)

    @users = Hash.new
    @notifications.each do |item|
      if @users[item.user_id].nil?
        @users[item.user_id] = item.count.to_i
      else
        @users[item.user_id] += item.count.to_i
      end
    end

    @users.each do |user_id, count|
      user = User.find(user_id)

      # only sent once for one user
      next if user.email.blank? || !user.email_option.comment

      UserMailer.comment_notify_email(user, count).deliver

      user.notifications.where(:category => 'comment', :notified => false).update_all(:notified => true)
    end

  end
end

