class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :firstname, :lastname, :image, :provider, :uid
  # attr_accessible :title, :body

  validates_presence_of :firstname

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

  def friend?(user)
      friend = false
      user.friends.each do |f|
        if f == self
          friend = true
        end
      end
      friend
  end

  has_many :listships
  has_many :followlists, :through => :listships, :source => :followlist

  after_create :set_default


  
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)    
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      #found an existing user
      #if user.first_name.nil?
        #but must update facebook details since not previously stored
      #  user.update_attributes(first_name:auth.info.first_name,
      #                     last_name:auth.info.last_name,
      #                     location:auth.info.location,
      #                     image:auth.info.image)                  
      #end
    else
      user = User.create(provider:auth.provider,
                           uid:auth.uid,
                           email:auth.info.email,
                           password:Devise.friendly_token[0,20],
                           firstname:auth.info.first_name,
                           lastname:auth.info.last_name,
                           image:auth.info.image,
                           remember_me: true                         
                           )
    end
    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  private

    def set_default
        title = "Services"
        tag = title.downcase
        list = List.new(title: title, tag_list: tag, privacy: 1, sort_by: "category", reserved: true)
        list.user = self
        list.save

        title = "Vacation Spots"
        tag = title.downcase
        list = List.new(title: title, tag_list: tag, privacy: 1, sort_by: "category", reserved: true)
        list.user = self
        list.save

        title = "Restaurants"
        tag = title.downcase
        list = List.new(title: title, tag_list: tag, privacy: 1, sort_by: "category", reserved: true)
        list.user = self
        list.save

        title = "Movies"
        tag = title.downcase
        list = List.new(title: title, tag_list: tag, privacy: 1, sort_by: "category", reserved: true)
        list.user = self
        list.save

        title = "Books"
        tag = title.downcase
        list = List.new(title: title, tag_list: tag, privacy: 1, sort_by: "category", reserved: true)
        list.user = self
        list.save
        item = Item.new(name: "The Name of the Wind (Kingkiller Chronicles, Da...",
          initial_comment:"Hey this is Patrick, I made this site. Favy is the best way to keep track of your favorite things and see what your friends like too. This is my favorite book. 
          Now delete this book and add your favorite!")
        item.image = "http://ecx.images-amazon.com/images/I/51qxhokQlWL._SL160_.jpg"
        item.list = list
        item.category_name = "Fantasy"      
        item.save
    end    




end
