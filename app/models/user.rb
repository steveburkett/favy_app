class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :firstname, :lastname
  # attr_accessible :title, :body

  has_many :lists, dependent: :destroy
  has_many :comments, dependent: :destroy


  has_many :friendships
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :direct_friends, :through => :friendships, :conditions => "approved = true", :source => :friend
  has_many :inverse_friends, :through => :inverse_friendships, :conditions => "approved = true", :source => :user

  has_many :pending_friends, :through => :friendships, :conditions => "approved = false", :foreign_key => "user_id", :source => :friend
  has_many :requested_friendships, :through => :inverse_friendships, :foreign_key => "friend_id", :conditions => "approved = false", :source => :user

  def friends
    direct_friends | inverse_friends
  end

end
