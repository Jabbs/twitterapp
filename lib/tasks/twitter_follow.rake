namespace :twitter do
  desc 'Populate database with twitter_accounts'
  task :follow => :environment do
    hour = Time.now.hour
    min = Time.now.min
    fits_min_slot = false
    if (5..15).include?(min) || (25..35).include?(min) || (45..55).include?(min)
      odd_time_slot = true
    end
    
    # 11:00pm to 6:59am CST do not disturb
    unless (5..12).include?(hour) && odd_time_slot == false
      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
        config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
        config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
        config.access_token_secret = ENV["TWITTER_ACCESS_SECRET"]
      end
      
      TwitterAccount.where(following: false).where(unfollowed: false).where(not_valid: false).first(15).each do |twitter_account|
        local_date_time = DateTime.now.in_time_zone("Central Time (US & Canada)").strftime("%m/%e/%y %l:%M")
        begin 
          client.follow(twitter_account.screen_name)
          Rails.logger.info "Trip_Sharing followed #{twitter_account.screen_name} at #{local_date_time}"
          twitter_account.follow_start = local_date_time
          twitter_account.following = true
          twitter_account.save
        rescue Twitter::Error => e
          Rails.logger.info "ERROR: #{e.class} #{e.message} #{twitter_account.screen_name} at #{local_date_time}"
          if e.class == Twitter::Error::NotFound
            twitter_account.not_valid = true
            twitter_account.save
          end
        end
      end
    end
  end
  
  task :unfollow => :environment do
    
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
      config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
      config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
      config.access_token_secret = ENV["TWITTER_ACCESS_SECRET"]
    end
    
    TwitterAccount.where(following: true).where(unfollowed: false).where("follow_start < ?", 3.days.ago).order("RANDOM()").each do |twitter_account|
      local_date_time = DateTime.now.in_time_zone("Central Time (US & Canada)").strftime("%m/%e/%y %l:%M")
      begin
        friendship = client.friendship(client, twitter_account.screen_name)
        if friendship.attrs[:source][:followed_by] != true || twitter_account.follow_start < 7.days.ago
          client.unfollow(twitter_account.screen_name)
          Rails.logger.info "Trip_Sharing unfollowed #{twitter_account.screen_name} at #{local_date_time}"
          twitter_account.unfollowed_at = local_date_time
          twitter_account.unfollowed = true
          twitter_account.save
        else
          twitter_account.friends = true
          twitter_account.save
        end
      rescue Twitter::Error
        Rails.logger.info "THERE WAS AN ISSUE unfollowing #{twitter_account.screen_name} at #{local_date_time}"
      end
    end
  end
  
  task :unfollow_all => :environment do
        
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
      config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
      config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
      config.access_token_secret = ENV["TWITTER_ACCESS_SECRET"]
    end
    
    TwitterAccount.where(following: true).where(unfollowed: false).each do |twitter_account|
      local_date_time = DateTime.now.in_time_zone("Central Time (US & Canada)").strftime("%m/%e/%y %l:%M")
      begin
        client.unfollow(twitter_account.screen_name)
        Rails.logger.info "Trip_Sharing unfollowed #{twitter_account.screen_name} at #{local_date_time}"
        twitter_account.unfollowed_at = local_date_time
        twitter_account.unfollowed = true
        twitter_account.save
      rescue Twitter::Error
        Rails.logger.info "THERE WAS AN ISSUE unfollowing #{twitter_account.screen_name} at #{local_date_time}"
      end
    end
  end
  
end