class SwitchNameOfInvalid < ActiveRecord::Migration
  def change
    remove_column :twitter_accounts, :invalid
    add_column :twitter_accounts, :not_valid, :boolean, default: false
  end
end
