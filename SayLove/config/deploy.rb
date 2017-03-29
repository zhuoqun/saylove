set :application, "SayLove"
set :repository,  "git@bitbucket.org:zhuoqun/saylove.git"

set :scm, :git

set :port, 30022
set :deploy_to, "/home/zhuoqun/www/SayLove"
set :use_sudo, false

role :web, "124.42.35.140"                          # Your HTTP server, Apache/etc
role :app, "124.42.35.140"                          # This may be the same as your `Web` server
role :db,  "124.42.35.140", :primary => true # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"
require 'capistrano-unicorn'
before "deploy:update", "unicorn:stop"
after "deploy:update", "unicorn:start"

desc "Import exists quotes, users and letters"
task :import_data, :roles => :app do
  run "cd #{deploy_to}/current && rake RAILS_ENV=production data:import_quotes"
  run "cd #{deploy_to}/current && rake RAILS_ENV=production data:import_users"
  run "cd #{deploy_to}/current && rake RAILS_ENV=production data:import_letters"
end
