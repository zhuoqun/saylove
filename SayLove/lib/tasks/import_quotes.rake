namespace :data do
  desc "Import quotes from files to database"
  task :import_quotes => :environment do

    File.open('/tmp/quotes', 'r').each_line do |line|
      quote = Quote.new
      quote.content = line.gsub(/\n/, '');
      quote.save
    end

  end
end
