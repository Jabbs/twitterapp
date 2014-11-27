class CreateTwitterAccounts < ActiveRecord::Migration
  def change
    create_table :twitter_accounts do |t|
      t.string :screen_name
      t.string :full_name
      t.string :location
      t.integer :followers
      t.integer :friends
      t.datetime :creation_date
      t.integer :tweet_count
      t.datetime :last_tweet
      t.text :bio
      t.text :url
      t.string :perc_tweets_w_url
      t.string :perc_retweets_in_timeline
      t.string :perc_tweets_w_at_contact
      t.string :social_authority

      t.timestamps
    end
  end
end
