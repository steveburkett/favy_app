class Friendship < ActiveRecord::Base
  attr_accessible :approved, :friend_id, :user_id

  belongs_to :user
  belongs_to :friend, :class_name => "User", :foreign_key => "friend_id"
end
