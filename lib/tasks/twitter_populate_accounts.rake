require 'csv'

namespace :twitter do
  desc 'Populate database with twitter_accounts'
  task :populate_accounts => :environment do
        
    CSV.foreach('lib/assets/1417107722.csv', headers: true, :encoding => 'windows-1251:utf-8') do |row|
      
      screen_name = row[0]
      
      unless TwitterAccount.find_by_screen_name(screen_name)
        twitter_account = TwitterAccount.create(screen_name: screen_name)
        puts twitter_account.screen_name
      end
    end

  end
  
end
