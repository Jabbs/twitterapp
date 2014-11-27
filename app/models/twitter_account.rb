class TwitterAccount < ActiveRecord::Base
  
  validates :screen_name, presence: true, uniqueness: true
end
