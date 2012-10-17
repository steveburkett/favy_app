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
    @tag = params[:tag]

  	#is current_user friends with @user?
  	#must optimize this later, must be better way
  	f = Benchmark.measure do
      @friend = false
    	@user.friends.each do |f|
    		if f == current_user
    			@friend = true
    		end
    	end
    end
    puts "time to check user is a friend"
    puts f

  	if @followedlists
  		#these are followed lists of currently viewed user
  		#have another privacy setting for friends of friends later
  		#for now current_user can only see user's public lists here
	  	if @user == current_user
	  		#current_user can see his own followlists, those that are 
	  		#public or set to friends. That is, a friend may have set
	  		#back to private so dont show those.
			  @lists = @user.followlists.where("privacy = ? OR privacy = ?", 0, 1)
	  	else
        #for now a current_user can't see a user's followed lists if those are friends lists
        #eventually want to see friend's of friends lists
	  		@lists = @user.followlists.where("privacy = ?", 0)
	  	end
  	elsif @search
      
      friends_ids = []
      current_user.friends.each do |f|
        friends_ids.push(f.id)
      end
      self_and_friends_ids = friends_ids.push(current_user.id)

      list_array = []
      List.where(:user_id => self_and_friends_ids).each do |l|
        list_array.push(l.id)
      end


      list_array_searched = []
      search_benchmark = Benchmark.measure do
        list_array_searched = list_array.select{ |l| !List.find(l).items.find(:all, :conditions => ['lower(name) LIKE ?', "%#{params[:search].downcase}%"]).empty? or !List.find(l).tags.find(:all, :conditions => ['lower(name) LIKE ?', "%#{params[:search].downcase}%"]).empty? or (List.find(l).title == params[:search])  } 
      end
      puts "search all friends list"
      puts search_benchmark


      #texticle_benchmark = Benchmark.measure do
      #  self_and_friends_lists.each do |l|
      #    if !l.items.search(params[:search]).empty?
      #      lists_with_item << l
      #    end
      #  end
      #end
      #puts "texticle"
      #puts texticle_benchmark
      @lists = List.where(:id => list_array_searched)
    else
  		if @user == current_user
  		  	@lists = @user.lists
  		elsif @friend
  			@lists = @user.lists.where("privacy = ? OR privacy = ?", 0, 1)
  		else #current_user not viewing himself or a friend so only show @user's public lists
  			@lists = @user.lists.where("privacy = ?", 0)
  		end
  	end

    if @tag
      @lists = @lists.tagged_with(params[:tag])
    end

    @lists.each do |l|
      puts l.tags
      puts l.tag_counts
    end

    @tagcounts = []
    if not @lists.empty? #for search results
      @tagcounts = @lists.tag_counts
      @lists = @lists.order("created_at DESC")
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
