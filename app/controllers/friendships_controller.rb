class FriendshipsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
  end

  def create
    @friendship = current_user.friendships.build(:friend_id => params[:friend_id], :approved => false)
    if @friendship.save
      flash[:notice] = "Request sent."
      redirect_to user_path(id: params[:friend_id])
    else
      flash[:error] = "Unable to send request."
      redirect_to root_path
    end
  end

  def approve
    f = Friendship.where("user_id = ? and friend_id = ?", params[:user_id], current_user.id).first
    f.update_attributes(:approved => true)
    flash[:notice] = "Friend Approved"
    redirect_to friends_path(current_user)
  end

  def ignore
    Friendship.where("user_id = ? and friend_id = ?", params[:user_id], current_user.id).first.destroy
    flash[:notice] = "Friend Request Ignored"
    redirect_to friends_path(current_user)
  end

  def destroy
    Friendship.where("(user_id = ? and friend_id = ?) or (user_id = ? and friend_id = ?)",
     current_user.id, params[:friend_id], params[:friend_id], current_user.id).first.destroy
    redirect_to friends_path(current_user)
  end
end
