class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
  	@user = User.find(params[:id])
  	@followedlists = params[:followedlists]

  	#is current_user friends with @user?
  	#must optimize this later, must be better way
  	friend = false
  	@user.friends.each do |f|
  		if f == current_user
  			friend = true
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
	  		@lists = @user.followlists.where("privacy = ?", 0).order("created_at DESC")
	  	end
	else
		if @user == current_user
		  	@lists = @user.lists.order("created_at DESC")
		elsif friend
			@lists = @user.lists.where("privacy = ? OR privacy = ?", 0, 1).order("created_at DESC")
		else #current_user not viewing himself or a friend so only show @user's public lists
			@lists = @user.lists.where("privacy = ?", 0).order("created_at DESC")
		end
	end


  @lists = @lists.paginate(:page => params[:page], :per_page => 5)
  
  end

  def index
  	@users = User.order(:lastname).paginate(:page => params[:page], :per_page => 20)
    puts @users
  end

  def friends
  	@user = User.find(params[:id])
  end
end
