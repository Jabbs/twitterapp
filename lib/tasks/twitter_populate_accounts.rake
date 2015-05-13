require 'csv'

namespace :twitter do
  desc 'Populate database with twitter_accounts'
  task :populate_accounts => :environment do
    
    # 1417107722.csv was the original 50k twitter account list with keyword travel
    # no other details about tweet min/max, follower min/max, or following min/max
    # (same with all the numbered lists... not much detail)
    
    array_old_screen_names = []
    CSV.foreach('lib/assets/1417107722.csv', headers: true, :encoding => 'windows-1251:utf-8') do |row|
      screen_name = row[0]
      array_old_screen_names << screen_name
    end
    puts "#{array_old_screen_names.count} in 1417107722.csv"
    
    array49408 = []
    CSV.foreach('lib/assets/49408_travel_minT_1000_maxT_4000.csv', headers: true, :encoding => 'windows-1251:utf-8') do |row|
      screen_name = row[0]
      array49408 << screen_name
    end
    puts "#{array49408.count} in array49408.csv"
    
    array49461 = []
    CSV.foreach('lib/assets/49461_travel_minT_120_maxT_999.csv', headers: true, :encoding => 'windows-1251:utf-8') do |row|
      screen_name = row[0]
      array49461 << screen_name
    end
    puts "#{array49461.count} in array49461.csv"
    
    # changed from first to last
    combined_49461_and_49408_first_50k = array49408.last(25000) + array49461.last(25000)
    puts "#{combined_49461_and_49408_first_50k.count} in combined_49461_and_49408_first_50k.csv"
    
    count = 0
    combined_49461_and_49408_first_50k.each do |screen_name|
      
      # didnt include bc only 7 names matched from before. decided to just destroy
      # all and repopulate
      # 
      # unless array_old_screen_names.include?(screen_name)
      #   twitter_account = TwitterAccount.create(screen_name: screen_name)
      #   count += 1
      # end
      
      if TwitterAccount.create(screen_name: screen_name)
        count += 1
      end
      
    end
    puts "#{count} twitter accounts created in TwitterBot."
    
  end
  
end
