namespace :twitter do
  desc 'Populate database with twitter_accounts'
  task :follow => :environment do
        
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
      config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
      config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
      config.access_token_secret = ENV["TWITTER_ACCESS_SECRET"]
    end
    
    TwitterAccount.where(following: false).where(unfollowed: false).where(not_valid: false).first(15).each do |twitter_account|
      begin 
        client.follow(twitter_account.screen_name)
        Rails.logger.info "Trip_Sharing followed #{twitter_account.screen_name} at #{DateTime.now}"
        twitter_account.follow_start = DateTime.now
        twitter_account.following = true
        twitter_account.save
      rescue Twitter::Error
        Rails.logger.info "THERE WAS AN ISSUE following #{twitter_account.screen_name} at #{DateTime.now}"
        twitter_account.not_valid = true
        twitter_account.save
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
    
    TwitterAccount.where(following: true).where(unfollowed: false).each do |twitter_account|
      
      if 14.days.ago > twitter_account.follow_start
        begin 
          client.unfollow(twitter_account.screen_name)
          Rails.logger.info "Trip_Sharing unfollowed #{twitter_account.screen_name} at #{DateTime.now}"
          twitter_account.unfollowed_at = DateTime.now
          twitter_account.unfollowed = true
          twitter_account.save
        rescue Twitter::Error
          Rails.logger.info "THERE WAS AN ISSUE unfollowing #{twitter_account.screen_name} at #{DateTime.now}"
        end
      end
    end

  end
  
end