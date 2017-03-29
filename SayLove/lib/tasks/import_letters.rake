namespace :data do
  desc "import mails data from files to database"

  task :import_letters => :environment do
    File.open('/tmp/letters.data').each_line do |line|
      item = line.split("\t")
      next if item[0] == 'title:douban_id'
      provider = Provider.find_by_uid(item[0])

      letter = Letter.new
      letter.user_id = provider.user.id
      letter.contact_type = 'douban'
      letter.contact_id = item[1]

      letter.content = ''
      letter.content += '<p>' + item[2] + '</p>' if item[2].present?
      letter.content += '<p>' + item[3] + '</p>'

      letter.is_public = item[4]
      letter.created_at = item[5]
      letter.notified = item[6]
      letter.has_echo = item[7]
      letter.is_viewed = item[8]

      letter.save

    end
  end
end
