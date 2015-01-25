class TwitterAccountsController < ApplicationController
  
  def index
    @twitter_accounts = TwitterAccount.order("screen_name ASC").paginate(page: params[:page], per_page: 50)
    @twitter_account_followings_count = TwitterAccount.where(following: true).where(unfollowed: false).size
  end
  
  def friends
    @twitter_account_friends = TwitterAccount.where(friends: true).order("screen_name ASC").paginate(page: params[:page], per_page: 50)
  end
  
  def destroy
    @twitter_account = TwitterAccount.find(params[:id])
    @twitter_account.destroy
    redirect_to root_path, notice: "Twitter Account has been removed."
  end
end
