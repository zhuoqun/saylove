# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

APP_PATH = '/home/zhuoqun/www/SayLove/current'
set :output, APP_PATH + "/log/cron_log.log"

every 4.hours do
  rake "mailer:send_echo_email"
  rake "mailer:send_flower_email"
  rake "mailer:send_comment_email"
end

# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
