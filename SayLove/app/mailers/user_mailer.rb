class UserMailer < ActionMailer::Base
  default from: '"Say Love" <postboy@isaylove.com>'

  def echo_notify_email(user)
    @text = t(:mail_echo_text)
    @view_link = echobox_url

    mail(:to => user.email, :subject => t(:mail_subject), :template_name => 'email')
  end

  def flower_notify_email(user, count)
    @text = t(:mail_flower_text, :count => count)
    @view_link = notifications_url

    mail(:to => user.email, :subject => t(:mail_subject), :template_name => 'email')
  end

  def comment_notify_email(user, count)
    @text = t(:mail_comment_text, :count => count)
    @view_link = notifications_url

    mail(:to => user.email, :subject => t(:mail_subject), :template_name => 'email')
  end

end
