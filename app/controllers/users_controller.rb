require 'will_paginate/array'

class UsersController < ApplicationController
  before_filter :authenticate_user!

  def search
    redirect_to user_path(id:current_user.id, search:params[:search])
  end

  def show
  	@user = User.find(params[:id])
  	@followedlists = params[:followedlists]
    @search = params[:search]

  	#is current_user friends with @user?
  	#must optimize this later, must be better way
  	@friend = false
  	@user.friends.each do |f|
  		if f == current_user
  			@friend = true
  		end
  	end


  	if @followedlists
  		#these are followed lists of currently viewed user
  		#have another privacy setting for friends of friends later
  		#for now current_user can only see user's public lists here
	  	if @user == current_user
	  		#current_user can see his own followlists, those that are 
	  		#public or set to friends. That is, a friend may have set
	  		#back to private so dont show those.
			  @lists = @user.followlists.where("privacy = ? OR privacy = ?", 0, 1).order("created_at DESC")
	  	else
        #for now a current_user can't see a user's followed lists if those are friends lists
        #eventually want to see friend's of friends lists
	  		@lists = @user.followlists.where("privacy = ?", 0).order("created_at DESC")
	  	end
      @lists = @lists.paginate(:page => params[:page], :per_page => 5)
	elsif @search
    
    friends_lists = []
    current_user.friends.each do |f|
      friends_lists = friends_lists | f.lists
    end
    self_and_friends_lists = current_user.lists | friends_lists
    
    lists_with_item = []
    self_and_friends_lists.each do |l|
      if !l.items.find(:all, :conditions => ['lower(name) LIKE ?', "%#{params[:search].downcase}%"]).empty?
        lists_with_item << l
      end
    end
    puts lists_with_item
    @lists = lists_with_item.paginate(:page => params[:page], :per_page => 5)
  else
		if @user == current_user
		  	@lists = @user.lists.order("created_at DESC")
		elsif @friend
			@lists = @user.lists.where("privacy = ? OR privacy = ?", 0, 1).order("created_at DESC")
		else #current_user not viewing himself or a friend so only show @user's public lists
			@lists = @user.lists.where("privacy = ?", 0).order("created_at DESC")
		end
    @lists = @lists.paginate(:page => params[:page], :per_page => 5)

	end


  
  end

  def index
  	@users = User.order(:lastname).paginate(:page => params[:page], :per_page => 20)
    puts @users
  end

  def friends
  	@user = User.find(params[:id])
  end
end
