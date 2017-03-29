namespace :data do
  desc "import users data from files to database"

  task :import_users => :environment do
    File.open('/tmp/users.data').each_line do |line|
      info = line.split("\t")
      next if info.first == 'title:douban_id'
      user = User.new
      user.user_name = info.first
      user.created_at = info.last
      user.save

      provider = Provider.new
      provider.provider = 'douban'
      provider.uid = info.first
      provider.url = 'http://www.douban.com/people/' + info.first
      provider.user_id = user.id
      provider.save
    end
  end
end
