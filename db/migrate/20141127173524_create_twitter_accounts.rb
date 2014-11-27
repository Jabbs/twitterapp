class CreateTwitterAccounts < ActiveRecord::Migration
  def change
    create_table :twitter_accounts do |t|
      t.string :screen_name
      t.datetime :follow_start
      t.boolean :unfollowed, default: false
      t.datetime :unfollowed_at
      t.boolean :following, default: false

      t.timestamps
    end
    add_index :twitter_accounts, :screen_name
  end
end
