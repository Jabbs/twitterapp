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
    
    TwitterAccount.where(following: true).where(unfollowed: false).where("follow_start < ?", 4.days.ago).order("RANDOM()").each do |twitter_account|
      begin
        # friendship = client.friendship(client, twitter_account.screen_name)
        # unless friendship.attrs[:source][:followed_by] == true
          client.unfollow(twitter_account.screen_name)
          Rails.logger.info "Trip_Sharing unfollowed #{twitter_account.screen_name} at #{DateTime.now}"
          twitter_account.unfollowed_at = DateTime.now
          twitter_account.unfollowed = true
          twitter_account.save
        # end
      rescue Twitter::Error
        Rails.logger.info "THERE WAS AN ISSUE unfollowing #{twitter_account.screen_name} at #{DateTime.now}"
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