namespace :mailer do
  desc "Send mails to people who subscribe the notifications when there is echo letters"

  task :send_echo_email => :environment do

    @letters = Letter.where(:has_echo => true, :notified => false)

    sent = Array.new
    @letters.each do |letter|
      user = letter.user

      # only sent once for one user
      next if sent.include?(user.id) || user.email.blank? || !letter.user.email_option.echo

      UserMailer.echo_notify_email(user).deliver

      letter.update_attributes(:notified => true)
      sent.push(user.id)
    end

  end
end

